# FuelMod: Project Zomboid renewable fuel mod

Lua + script mod for **Project Zomboid Build 42.20+**. Design and plans live in
`docs/`. Read `docs/roadmap.md` for the current milestone and
`docs/api-notes.md` before touching any game API.

## Where things are

- Game install: `C:\Games\Steam\steamapps\common\ProjectZomboid`.
  Vanilla Lua (`media/lua`) and scripts (`media/scripts/generated`) are the
  API reference. Grep them before writing code.
- User data and logs: `%USERPROFILE%\Zomboid\` (`console.txt` is the live log).
- Mod source: `mod/FuelMod/42/` (B42 versioned folder) plus an empty `common/`.

## Rules

- Never guess an API. Verify it in vanilla code or in game, and record new
  findings in `docs/api-notes.md`.
- B42 syntax only: namespaced values (`ItemType = base:normal`),
  `craftRecipe` blocks, JSON translations in `lua/shared/Translate/EN/`.
- Lua files go under `lua/{client,server,shared}/FuelMod/`, because files with
  the same relative path override vanilla.
- Persistent state goes in object ModData, never Lua globals. Time comes
  from `getGameTime():getWorldAgeHours()`, never real-time timers.
- Keep it small: no frameworks, no speculative abstractions.

## Gotchas

- Install with `install.cmd` (a copy). A junction or symlink breaks the
  game's script checksum.
- Non-Base recipes are looked up module-qualified:
  `getScriptManager():getCraftRecipe("FuelMod.FuelMod_MakeCornMash")`.
- The dedicated server never applies mod translations. Check names in the client.

## Workflow

- After changes: `install.cmd`, then test in game (`-debug`, a sandbox test save).
- Headless load check without the GUI: see `docs/development.md`.
- Commits use Conventional Commits (`feat:`, `fix:`, `docs:`, `build:`, `chore:`).
