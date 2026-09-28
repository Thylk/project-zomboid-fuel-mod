# Development Guide

## Install the mod locally

The source lives in `mod/FuelMod/`. The game reads mods from
`%USERPROFILE%\Zomboid\mods\`. Copy it there with:

```bat
install.cmd
```

This mirrors the folder with `robocopy /MIR`. Run it after every change.
Don't use a junction or symlink instead, because the game's script checksum
breaks on them (see [api-notes.md](api-notes.md)).

## Enable the mod

1. Launch Project Zomboid (Build 42).
2. Main menu → **Mods** → enable **Renewable Fuel**.
3. For an existing save: **Load** → select the save → **More** → mods, enable it.

## Test environment

Make a dedicated test save so experiments never touch real playthroughs:

- **Sandbox** game, zombies off or very low, starter kit on.
- Launch with `-debug` (Steam → Properties → Launch Options) to get the
  debug menu, item spawner and in-game Lua console.

Smoke test for the skeleton:

1. Spawn two `Base.Corn` and a bottle of water with the debug item list.
2. Open the crafting menu, **Farming** category → **Make Corn Mash**.
3. Craft it and confirm **Corn Mash** appears with its English name.
4. Save, quit to menu, reload, and confirm the item is still there.

## Logs and Lua errors

| What | Where |
|------|-------|
| Current session log | `%USERPROFILE%\Zomboid\console.txt` |
| Older sessions | `%USERPROFILE%\Zomboid\Logs\` |
| Live log window | `ProjectZomboid64ShowConsole.bat` in the game folder |

Our messages are prefixed `[FuelMod]`. Search the log for the mod:

```sh
grep -n "FuelMod\|ERROR\|LuaError" ~/Zomboid/console.txt
```

A healthy load shows `loading FuelMod` then `[FuelMod] Lua loaded`.
In debug mode, Lua errors also appear as a red counter at the bottom right.

## Headless check (no GUI)

The dedicated server can confirm that scripts and Lua load without launching
the game. It uses an isolated cache dir, so real saves stay untouched.

1. Run the command below once. It generates `<cache>/Server/fuelmodtest.ini`.
2. Set `Mods=FuelMod` in that file and copy `mod/FuelMod` to `<cache>/mods/`.
3. Run it again and grep the log.

```sh
cd "/c/Games/Steam/steamapps/common/ProjectZomboid"
timeout 180 ./jre64/bin/java.exe --enable-native-access=ALL-UNNAMED \
  --add-exports=java.base/jdk.internal.misc=ALL-UNNAMED -XX:+UseZGC -Xmx3072m \
  "-Djava.library.path=./natives/;./natives/win64/;./" -cp "./;projectzomboid.jar" \
  zombie.network.GameServer -nosteam "-cachedir=C:\path\to\pzcache" \
  -servername fuelmodtest -adminpassword devtest > server.log 2>&1
grep -n "FuelMod\|SERVER STARTED" server.log
```

The server does not run client Lua and does not resolve mod translations.
Final checks always happen in the real game.

## Workflow

```text
Implement small feature → install.cmd → launch with -debug → test in test save
→ check console.txt → fix → commit
```
