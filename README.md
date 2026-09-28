# Renewable Fuel (FuelMod)

A Project Zomboid mod adding a difficult, late-game renewable fuel chain:
crops → fermentation → distillation → biofuel → generators.
Gasoline stays valuable: biofuel is weaker and costly to produce.

## Status

**Prototype skeleton (milestone 0).** The mod loads, registers a test item
and a test recipe. No fuel system yet. See [docs/roadmap.md](docs/roadmap.md).

## Supported version

Project Zomboid **Build 42.20+** (developed on 42.20.4). Build 41 is not
supported: item and recipe scripts use B42-only syntax.

## Current features

- Item **Corn Mash** (`FuelMod.CornMash`), placeholder icon.
- Recipe **Make Corn Mash**: 2 Corn + 1 L Water, Farming category.

## Planned features

- Fermentation barrel world object with persistent state
  (empty → fermenting → ready), driven by in-game time.
- Still: fermented mash → ethanol → biofuel.
- Biofuel for generators at reduced efficiency, all values configurable.
- Later: multiplayer, hazards, custom art, vehicle conversion.

Design details: [docs/vision.md](docs/vision.md).

## Installation

Run `install.cmd` from the repository root. It copies `mod/FuelMod` into
`%USERPROFILE%\Zomboid\mods\FuelMod`. Then enable **Renewable Fuel** in the
game's Mods menu.

## Development

See [docs/development.md](docs/development.md) for the test procedure and
log locations, and [docs/api-notes.md](docs/api-notes.md) for verified
B42 modding APIs.

## Project structure

```text
├── install.cmd         copy the mod into ~/Zomboid/mods
├── docs/               design, architecture, API notes, dev guide
└── mod/FuelMod/
    ├── common/         required by B42, empty
    └── 42/
        ├── mod.info
        └── media/
            ├── lua/{client,server,shared}/FuelMod/
            ├── lua/shared/Translate/EN/
            ├── scripts/        items and recipes
            └── textures/FuelMod/
```

## License

MIT. See [LICENSE](LICENSE).
