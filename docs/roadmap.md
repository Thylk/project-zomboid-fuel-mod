# Roadmap

## Milestone 0: skeleton (current)

- [x] Repository structure
- [x] `mod.info` (B42 layout)
- [x] Minimal Lua entry point
- [x] README
- [x] Test item (`FuelMod.CornMash`)
- [x] Test recipe (2 Corn + 1 L Water → Corn Mash)
- [x] Development/test procedure ([development.md](development.md))
- [x] Mod loads, item and recipe register (verified on headless dedicated server)
- [ ] Verified in the game client: recipe craftable, English names shown

Do not start the barrel until this is confirmed in game.

## Milestone 1: vertical slice

Prove the mod can:

1. Load successfully.
2. Register a custom item.
3. Register a basic recipe.
4. Create or identify a world object as a fermentation barrel.
5. Attach persistent custom state (ModData) to it.
6. React to a game event.
7. Change the object's state over in-game time.
8. Change its sprite with state, if practical.

Placeholder/vanilla assets only. No final art.

## Later milestones (order not fixed)

- Distillation: Fermented Mash → Still → Ethanol
- Biofuel as a custom fluid, usable in generators
- Sandbox options for durations and efficiency
- Multiplayer: server-authoritative commands
- BROKEN state and hazards
- Custom art
- Vehicle biofuel conversion
