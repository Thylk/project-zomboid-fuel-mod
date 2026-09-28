# Architecture

## Technical constraints

- The engine is Java. **Never modify it.** Mods use Lua plus script/data
  files (items, recipes, fluids) and the Lua API exposed by the engine.
- Target the installed game version (see [api-notes.md](api-notes.md)).
  Do not trust APIs from older-build tutorials.
- No frameworks, build systems, package managers or speculative abstractions.

## Repository layout

```text
project-zomboid-fuel-mod/
├── README.md, LICENSE, .gitignore, install.cmd
├── docs/
└── mod/FuelMod/                 ← copied to ~/Zomboid/mods/FuelMod by install.cmd
    ├── common/                  ← required by B42 (may stay empty)
    └── 42/                      ← files for game version 42+
        ├── mod.info
        └── media/
            ├── lua/client/FuelMod/   context menus, UI (client only)
            ├── lua/server/FuelMod/   authoritative state changes
            ├── lua/shared/FuelMod/   config, constants, state logic
            ├── lua/shared/Translate/EN/*.json
            ├── scripts/              items, recipes, fluids
            └── textures/FuelMod/
```

Lua files live in a `FuelMod/` subfolder: a mod file with the same relative
path as a vanilla file replaces it.

## World object

The barrel/still is a world object, not an inventory item:

```text
World Object
├── Sprite (visual state)
├── Persistent ModData
├── Ingredients / inventory
└── Production state
```

State lives in the object's ModData, which is saved with the map chunk:

```lua
object:getModData().FuelMod = {
    state = "fermenting",
    startedAt = worldAgeHours,
    finishAt  = worldAgeHours + duration,
}
```

It must survive save, quit, restart and reload. **Never** keep gameplay state
in Lua globals.

## State machine

```text
EMPTY → FERMENTING → READY          (prototype)
EMPTY | FERMENTING | READY | BROKEN (later)
```

Each state should map to a sprite when practical
(`still_empty`, `still_fermenting`, `still_ready`). Vanilla sprites until
real art exists.

## Interaction

Use the vanilla world-object context menu
(`Events.OnFillWorldObjectContextMenu`), no custom UI. Prototype options:

```text
Start Fermentation / Check Status / Collect
```

Later: Add ingredients, Start fermentation, Check status, Collect product.

## Time

- No real-time timers. Use in-game time: `getGameTime():getWorldAgeHours()`.
- `finishAt = startedAt + duration`. Compare against current world age.
- Progress continues while the player is away, since it is derived from
  timestamps rather than ticked.
- Periodic checks via `Events.EveryTenMinutes` (in-game), never per frame.
  Better still: resolve state lazily when the object is loaded or inspected.

## Multiplayer

Single-player first, but keep the split so MP is a small step later:

```text
Client requests action → Server validates → Server mutates object state → State synced to clients
```

- Client never mutates inventory or resources directly.
- Vanilla pattern: `sendClientCommand` (client) → `Events.OnClientCommand`
  (server) → `object:transmitModData()` / `transmitUpdatedSpriteToClients()`.
- Do not build networking infrastructure until it is needed.

## Code quality

- Small functions, descriptive names, no global mutable state.
- Document non-obvious Zomboid API behaviour in comments.
- No abstraction without a real problem behind it.
- Never implement against a guessed API. When unsure:
  1. search the local install (`media/lua`, `media/scripts`),
  2. search vanilla Lua examples,
  3. check current modding docs,
  4. verify in-game.
