# Handoff
_Last updated: 2026-10-21 · by: Claude (cloud session that created the repo)_

## Current milestone
M0: Harness and toolchain (see docs/ROADMAP.md)

## Status
- [x] M0.1 Repo + Godot project (Godot 4.7.2, Mobile renderer, sensor landscape)
- [x] M0.2 GUT 9.7.1 vendored, gdtoolkit 4.5.0, Makefile, setup.sh, untyped declarations = error
- [ ] M0.3 CI green: workflow is committed, but its first run on GitHub hasn't been checked yet
- [x] M0.4 Docs: CLAUDE.md, GDD, ROADMAP, HANDOFF, DECISIONS, MAC_SETUP
- [ ] M0.5 SessionStart hook is committed (`.claude/settings.json` → `scripts/session-start.sh`).
      Still to do (human): set the Claude cloud environment's setup script, see "Cloud environment" below.
- [~] M0.6 `make shots` works on Linux under xvfb (verified: 90 frames rendered). Not yet tried on the Mac.
- [ ] M0.7 Blank build on iPhone (human, on the Mac; steps in docs/MAC_SETUP.md)

## Last session changed
- Created the project skeleton: autoloads (EventBus, Rng), core classes (SeededRng, Stats, StatMod,
  ModDef, Tuning), two example mods, tuning.tres, a placeholder title scene (`scenes/main.tscn`) with a
  spinning stand-in ship, and `scenes/debug/showcase.tscn` for screenshots.
- 17 GUT tests: stat math, RNG determinism and forking, data-file validation (mod ids, known stats,
  tuning), the asset-license ledger, and a main-scene boot smoke test. `make check` is green on Linux.
- Verified the harness fails when it should: a typo'd stat in a mod file fails `make test`, and an
  untyped variable fails compilation.

## Next up (in order)
1. **Mac (human):** follow docs/MAC_SETUP.md, clone, run `make setup && make check`. Report anything red.
2. **Mac (human):** M0.7. Export `scenes/main.tscn` to your iPhone. Commit `export_presets.cfg`
   (it holds no secrets; Godot keeps credentials in `.godot/export_credentials.cfg`, which is gitignored).
3. Confirm the first CI run is green on GitHub (M0.3).
4. Start M1.1: hover controller in `src/game/vehicle/`, reading `Tuning`.

## Needs device playtest (human answers inline)
- Q: Does `make check` pass on the Mac with Godot.app 4.7.2? → A:
- Q: Does the blank build launch on the iPhone in landscape, at full screen? → A:

## Known issues
- `make sim` and `make balance` deliberately exit 1 until M2.6 / M3.7.
- `make shots` also writes `frame.wav` (Movie Maker records audio). Harmless; reports/ is gitignored.

## Gotchas
- Godot imports any `.csv` as a translation by default. `assets/CREDITS.csv.import` sets
  `importer="keep"` so the ledger stays a plain file. Do the same for any future data CSV.
- The first `make import` on a fresh clone takes ~20 s and prints a lot (GUT's fonts). That's normal.
- `@warning_ignore_start("unused_signal")` in event_bus.gd is needed because signals are declared before
  anything emits them.

## Cloud environment (one-time, human)
In the Claude Code environment settings for this repo, set the setup script to:

```bash
apt-get update && apt-get install -y xvfb libgl1-mesa-dri unzip
```

The network policy must allow `github.com` (Godot download) and `pypi.org` (gdtoolkit). The SessionStart
hook then runs `scripts/setup.sh` automatically in cloud sessions.

## Kickoff prompt (paste into a new Claude Code session)

```
You're continuing development of Void Circuit, a roguelike hover-racer for iOS in Godot 4.

1. Read CLAUDE.md, then docs/HANDOFF.md, then the current milestone in docs/ROADMAP.md.
   Skim docs/GDD.md for the parts that touch the task.
2. Run `make setup && make check` and tell me the result before changing anything.
   If it's red, fixing it is the first task.
3. Read any answers I wrote under "Needs device playtest" and apply them.
4. Take the first item under "Next up". Work in small steps with tests.
   Run `make check` before each commit.
5. Before you finish: update HANDOFF.md and DECISIONS.md, commit, push, and open a PR.
   Summarize what to playtest on my phone.

Today's focus (optional): ___
```

## Parking lot
- Procedural track segments
- Daily seeded challenge run
- Combat items
- Tilt steering polish
