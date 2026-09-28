# Project Zomboid API Notes

Facts verified against the **installed game, build 42.20.4**
(`~/Zomboid/version.txt`, revision `b0bbce05d5`), unless marked *unverified*.
Re-check this file after game updates.

Game install: `C:\Games\Steam\steamapps\common\ProjectZomboid`.
Vanilla Lua is in `media/lua`, scripts in `media/scripts/generated`.
These are the best reference. Grep them before using any API.

## Mod layout (B42)

```text
~/Zomboid/mods/<ModId>/
├── common/          must exist, may be empty
└── 42/              versioned folder, used by game 42.x
    ├── mod.info
    └── media/...
```

- A mod without a `42/` folder is skipped. The log says
  `refusing to list examplemod` for the bundled B41-style example.
- `mod.info` keys seen in B42 mods: `name`, `id`, `description`, `author`,
  `modversion`, `versionMin`, `poster`, `icon`, `tiledef`, `pack`.
- **Do not install via a directory junction.** With a junction, the server
  logs `NetChecksum$Checksummer.addFile ... absPath:null` once per script
  file. A real copy loads cleanly. Use `install.cmd`.
- Every mod logs `NoSuchFileException` for missing `media/AnimSets` and
  `media/actiongroups`. That is harmless engine noise.
- Lua files are overridden by relative path across mods and vanilla. Keep
  ours under `lua/{client,server,shared}/FuelMod/`.

## Items

`media/scripts/*.txt`, inside `module <Name> { ... }`:

```text
item CornMash
{
    DisplayCategory = Food,
    ItemType = base:normal,
    Weight = 0.5,
    Icon = Corn,
}
```

- 42.20 uses namespaced registry values: `ItemType = base:normal`
  (also `base:food`, `base:drainable`, ...), `Tags = base:petrol`,
  `BodyLocation = base:hat`.
- `Icon = Corn` references a vanilla icon, as a placeholder.
- No `DisplayName` in item scripts. Names come from translation JSON.
- Full type is `Module.Name`, e.g. `FuelMod.CornMash`.

## Fuel is a fluid

Gasoline is `fluid Petrol` in `scripts/generated/fluids.txt`, with categories
`Fuel, Hazardous, Industrial`. Gas Can and Jerrycan are `base:normal`
items with a `component FluidContainer` holding `fluid = Petrol:1.0`.
Ethanol and Biofuel should be new `fluid` definitions poured into
existing containers. That decision is deferred to the distillation milestone.

## Craft recipes

B42 `craftRecipe` syntax, from `scripts/generated/recipes/`:

```text
craftRecipe FuelMod_MakeCornMash
{
    timedAction = Making,
    time = 60,
    category = Farming,
    Tags = AnySurfaceCraft,
    inputs
    {
        item 2 [Base.Corn],
        item 1 [*],
        -fluid 1.0 [Water],
    }
    outputs
    {
        item 1 FuelMod.CornMash,
    }
}
```

- `item 1 [*]` followed by `-fluid 1.0 [Water]` means "any container holding
  1 L of water". Vanilla uses it in `MakePieDough`.
- Tool inputs: `item 1 tags[base:saw] mode:keep flags[MayDegradeLight]`.
- `getScriptManager():getCraftRecipe(name)` needs the **module-qualified**
  name for non-Base modules: `"FuelMod.FuelMod_MakeCornMash"`. The bare name
  returns nil.

## Translations

JSON files at `media/lua/shared/Translate/<LANG>/<File>.json`:

- `ItemName.json`: `{ "FuelMod.CornMash": "Corn Mash" }`
- `Recipes.json`: `{ "FuelMod_MakeCornMash": "Make Corn Mash" }`
- `ContextMenu.json`, `Sandbox.json`, `Tooltip.json`, `UI.json` similarly.

The log line `mod "FuelMod" overrides .../itemname.json` does not wipe
vanilla names. `Base.PetrolCan` still resolves to "Gas Can".

On a **dedicated server**, mod translations do not resolve at all. This
applies to MoreBuilds too. Client-side translation is *unverified* until
tested in game.

## Lua events and time

- `Events.OnGameStart`: client, after a save loads.
- `Events.OnServerStarted`: dedicated server, after startup.
- `Events.EveryTenMinutes`, `Events.EveryHours`: in-game time ticks.
  Vanilla farming and campfire systems use `EveryTenMinutes`.
- `getGameTime():getWorldAgeHours()`: in-game hours since world start.
  Use it for `startedAt` and `finishAt`.

## Context menu

Vanilla pattern, from `client/ISUI/Hutch/ISHutchMenu.lua`:

```lua
local function onFill(playerNum, context, worldobjects, test)
    if test and ISWorldObjectContextMenu.Test then return true end
    for _, obj in ipairs(worldobjects) do --[[ find our object ]] end
    context:addOption(getText("ContextMenu_X"), target, callback, arg)
end
Events.OnFillWorldObjectContextMenu.Add(onFill)
```

`ISContextMenu:getNew(context)` plus `context:addSubMenu(option, sub)`
builds submenus.

## ModData and syncing

- `isoObject:getModData()` returns a Lua table persisted with the object.
- Server to clients: `isoObject:transmitModData()`,
  `isoObject:transmitUpdatedSpriteToClients()`,
  `isoObject:transmitCompleteItemToClients()`.
  See `server/Camping/SCampfireGlobalObject.lua`.
- Client to server: `sendClientCommand(player, module, command, args)`,
  handled by `Events.OnClientCommand.Add(fn)` on the server.
  See `server/ClientCommands.lua`.
- Vanilla world systems (farming, campfires) use the
  `SGlobalObjectSystem` / `CGlobalObjectSystem` framework in
  `lua/server/Map` and `lua/client/Map`. Evaluate it for the barrel before
  hand-rolling object tracking.

## Still to investigate (barrel milestone)

- How to place a barrel: a buildable entity (`scripts/entities/`) or
  tagging an existing vanilla barrel sprite.
- Changing sprites: `setSprite` / `setSpriteFromName` are *unverified*.
  Check the campfire's `syncSprite` first.
