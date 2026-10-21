# Void Circuit: Game Design

Working title. Roguelike hover-racer for iPhone, landscape, 60 fps target.
A run takes about 20 minutes over 3 sectors, and each race is about 90 seconds (3 laps).

## Inspiration

The reference is **Star Wars: Galactic Racer** (Fuse Games, Oct 6 2026), an arcade racer with a roguelike
campaign. You choose your path through a league one event at a time and can't back out of an event once it
is locked in. A wreck ends the run, and you build up your vehicle from parts as you go. Void Circuit keeps
that structure, uses an original setting (no Star Wars names or likenesses), and is cut down to fit a phone
and a solo developer.

| Galactic Racer | Void Circuit | Why |
|---|---|---|
| A single wreck ends the run | Hull bar, 5 pips. 0 = wreck = run over. | Touch steering is less precise than a controller |
| Branching league path | 3 sectors, each a small node map ending in a Sector Final | Same choice-driven tension, shorter sessions |
| 300+ parts, buildcraft | ~40 drafted mods with synergy tags, plus 4 chassis | Content one person can build and balance |
| Podracers, speeders, bikes | Hover craft only | One physics model, no wheels |
| Story rivalry | 4 named rival pilots in Duel events | Personality on a small budget |

## Core loop

Garage (spend Salvage, pick chassis) → start a run with a seed → league map: choose the next event →
play the event → draft 1 of 3 mods → back to the map. At 0 hull you wreck and the run ends. Winning the
Sector 3 Final makes you champion. Either way you're paid Salvage and return to the Garage.

## Feel and controls

- **Auto-accelerate.** The player only steers, drifts and boosts.
- **Steer:** hold the left or right half of the screen. Tilt steering is an option.
- **Drift:** hold both halves. Drifting charges the boost meter.
- **Boost:** a button in the bottom-right corner that spends the meter.
- **Camera:** chase cam with FOV that widens as speed rises. Bloom and fog hide the far track.
- **No weapons in v1.** Racers hurt each other by ramming.
- Every feel number lives in `data/tuning.tres`.

## Look

Flat-shaded low-poly ships, emissive neon trim with WorldEnvironment glow, fog for distance, a space HDRI
sky, and tracks extruded along a Path3D with glowing walls. No terrain, no wheels, no realistic lighting.

## Run structure

3 sectors. Each sector is a node map 4 columns deep with 2–3 choices per column, ending in a Sector Final.
The map is generated from the run seed, so the same seed always produces the same run.

| Event | What happens | Reward / cost |
|---|---|---|
| Race | 5 AI racers, 3 laps | Credits by place 60/40/25/10. Finishing below 4th costs 1 hull. |
| Elimination | Last place is knocked out at the end of each lap | Better draft. Getting eliminated costs 2 hull. |
| Time Trial | Solo run against a target time | Credits, no hull risk |
| Rival Duel | 1v1 against a named rival with their own build | Guaranteed Rare mod |
| Garage | Shop: buy mods, sell mods, reroll | Costs credits |
| Repair Bay | Restore 2 hull, or pay credits for a full repair | None |
| Mystery | Text event with a choice, e.g. "Take the unstable fuel? +boost, −1 hull" | Varies |
| Sector Final | Harder race. You must finish top 3. | Legendary draft. Failing ends the run. |

**Hull:** you start a run with 5 pips. A wall scrape costs 1 (with `scrape_cooldown` so it can't chain),
a racer collision costs 1, and a hazard costs 2. Hull carries between races.

## In-run mods

After each race you choose 1 of 3, weighted by rarity and sector. Tags: BOOST, DRIFT, HULL, DRAFT,
CREDITS, RISK. The draft slightly favors tags you already own. Each mod is a `ModDef` resource in
`data/mods/`.

| Mod | Rarity | Tags | Effect |
|---|---|---|---|
| Afterburner Coil | common | BOOST | +20% boost duration |
| Cold Fusion Cell | common | BOOST | Boost meter fills 15% faster |
| Drift Capacitor | common | DRIFT | A drift longer than 1.5 s ends with a mini-boost |
| Ablative Plating | common | HULL | +1 max hull |
| Pit Gremlin | common | HULL | Repair 1 hull after every event |
| Scrap Magnet | common | CREDITS | +5 credits per overtake |
| Perfect Start | common | BOOST | Hitting the launch window gives a 2 s boost |
| Slipstream Siphon | rare | DRAFT | Drafting behind a racer charges boost |
| Reactive Shield | rare | HULL | The first collision in each race does no damage |
| Chain Drift | rare | DRIFT | Consecutive clean drifts each give +10% boost, stacking to 5 |
| Ram Plating | rare | HULL | When you ram a racer, they take the damage and you don't |
| Overclocked Thrusters | rare | RISK | +10% top speed. Wall scrapes do double damage. |
| Bounty Chip | rare | CREDITS, RISK | +50% race credits, −1 max hull |
| Phoenix Core | legendary | HULL | Once per run, survive a wreck with 1 hull |
| Ion Wake | legendary | BOOST | While boosting you leave a trail that slows racers behind you |
| Gambler's Gyro | legendary | CREDITS, RISK | Shop prices −30%, but drafts show 2 choices instead of 3 |

Example synergy: Drift Capacitor + Chain Drift + Cold Fusion Cell.

On-track pickups are separate from mods: boost pads, and the occasional repair orb on risky lines.

## Meta progression

Every run pays **Salvage** based on sectors cleared, placements and a bonus for winning. The design rule is
that meta upgrades should mostly widen your options rather than add raw power.

| Garage section | Unlocks |
|---|---|
| Hangar | Mule (balanced, starter), Wasp (fast, 3 hull), Bastion (slow, 7 hull, ram bonus), Specter (phase-through dash) |
| Workshop | Capped upgrades: +1 starting hull (3 tiers), +10% starting credits, 1 free reroll per run, later a 4th draft choice |
| Research | Adds new mods to the draft pool (about 16 → 40) |
| Pilot License | After your first championship: Heat 1–10, each adding a modifier (aggressive AI, fewer repairs, ...) |
| Codex | Discovered mods, rivals, best times, run history |

## Architecture notes

- **Vehicle:** `CharacterBody3D` with an arcade hover controller. It raycasts to the track, aligns to the
  surface normal and applies its own accel, drag and steering curves from `Tuning`. No realistic physics.
- **Tracks:** a `Path3D` curve plus `CSGPolygon3D` in path mode for the road and walls. The same curve
  drives AI racing lines, checkpoints and progress.
- **AI:** follows the curve with a lookahead point, a lane offset and a skill value. Brakes into tight
  curvature. Mild rubber-banding, capped at ±8% speed.
- **Mods:** stat modifiers (`Stats.compute`: adds first, then multipliers) plus hook names fired via EventBus.
- **Randomness:** `Rng.start_run(seed)`, then `Rng.stream("map")`, `Rng.stream("draft")` and so on.
- **Save:** JSON in `user://profile.json` with `schema_version` and tested migrations.
