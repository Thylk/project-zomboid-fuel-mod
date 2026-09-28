# Vision and Gameplay Design

## Goal

A small Project Zomboid mod adding a **renewable fuel production** chain:

```text
Farming → Crops → Fermentation → Ethanol / Biofuel → Generator → Late-game renewable energy
```

The design goal is **not** "make gasoline infinite". It is to give players a
difficult, late-game renewable fuel infrastructure. Vanilla gasoline must stay
valuable.

## Production chain

### Fermentation

The player puts agricultural ingredients into a fermentation barrel.

```text
Corn + Water → (24–72 in-game hours) → Fermented Mash
```

Duration must be configurable.

### Distillation (later)

```text
Fermented Mash → Still → Ethanol → Biofuel → Generator
```

## Items

Eventually: Fermented Mash, Ethanol, Biofuel. Reuse vanilla items where
possible instead of creating redundant ones.

In Build 42, gasoline is a **fluid** (`Petrol`) held by items with a
`FluidContainer` component (Gas Can, Jerrycan). Ethanol and Biofuel should
most likely be custom fluids poured into vanilla containers, not new
container items. See [api-notes.md](api-notes.md).

## Balance

- Biofuel starts inferior to gasoline, roughly 70–80% effective efficiency.
- All values configurable (sandbox options).
- Sustaining a generator indefinitely should need a meaningful farming and
  processing operation. The player must dedicate resources and time.

## Progression

```text
EARLY GAME      Search gas stations, siphon cars, collect gasoline
MID GAME        Conserve gasoline, build generator infrastructure
LATE GAME       Farming → Fermentation → Distillation → Biofuel
VERY LATE GAME  Multiple barrels and stills, dedicated fuel crops,
                renewable generator infrastructure, vehicle conversion
```

## Future: vehicle support (not initially)

```text
Mechanics skill + vehicle modification + fuel conversion kit = vehicle can burn Biofuel
```

Penalties: worse fuel economy, reduced performance, increased engine wear.

## Future: hazards (not in prototype)

Fire, explosion, equipment failure, poor-quality fuel, contamination,
resource loss.
