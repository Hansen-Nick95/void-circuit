# Void Circuit: guide for Claude

Roguelike hover-racer for iOS, built in Godot 4 with GDScript.
**Read docs/HANDOFF.md first, every session.** Design: docs/GDD.md. Tasks: docs/ROADMAP.md.
Past decisions and their reasons: docs/DECISIONS.md. Don't reopen them without a new reason.

## Commands
- `make setup`    install the toolchain (Linux: pinned headless Godot into .tools/; macOS: checks Godot.app) + gdtoolkit
- `make check`    import + lint + format check + all tests. **Must pass before every commit.**
- `make test`     GUT tests, headless (tests/unit, tests/integration)
- `make fmt`      auto-format GDScript (gdformat)
- `make shots`    render 90 frames of scenes/debug/showcase.tscn to reports/shots/. Read a frame
                  to see what you built. Linux needs xvfb + mesa; macOS needs nothing extra.
- `make sim`      AI-only races on fixed seeds (not built yet, ROADMAP M2.6)
- `make balance`  Monte Carlo of seeded runs (not built yet, ROADMAP M3.7)

The pinned Godot version lives in `.godot-version`. The Makefile picks `/Applications/Godot.app`
on macOS and `.tools/godot` on Linux; override with `GODOT=/path/to/godot make check`.

## Layout
- `src/core/`     pure game rules (RefCounted / Resource classes, no scene tree). Fully unit tested.
- `src/game/`     node scripts for gameplay (vehicle, AI, race director). Thin; call into core.
- `src/ui/`       node scripts for menus and HUD.
- `src/autoload/` EventBus (signals), Rng (seeded streams). Registered in project.godot.
- `data/`         content as .tres Resources: mods/, chassis/, events/, tracks/, tuning.tres.
- `scenes/`       .tscn files. `scenes/debug/showcase.tscn` is what `make shots` renders.
- `assets/`       third-party art/audio. Every file needs a row in `assets/CREDITS.csv`.
- `tests/`        GUT tests. File names start with `test_`, functions start with `test_`.
- `addons/gut/`   vendored GUT 9.7.1. Don't edit.

## Rules
- Game rules live in src/core/ with no Node APIs. Every new rule gets a test in tests/unit/.
- Content is data. A new mod is a new `data/mods/<id>.tres` (id == filename) and needs no code
  unless it needs a new hook. Stats a mod may touch are listed in `Stats.KNOWN`.
- All randomness goes through `Rng.stream("<subsystem>")` (or `SeededRng` in core code).
  Never call `randf()` / `randi()` / `randomize()` directly.
- Static typing everywhere. Untyped declarations are compile errors (project setting).
- Systems talk through EventBus signals, not direct references across scenes.
- Feel numbers live in `data/tuning.tres` (class `Tuning`), not in scripts.
- Never hand-edit `.godot/`, `*.import` files or `uid://` values. Run `make import`.
- Hand-writing .tscn/.tres is fine, but use `[ext_resource type="Script" path="res://..."]` and let
  Godot add uids. After editing one, run `make test` to prove it still loads.
- Original names and setting only. No Star Wars names or likenesses.
- If you can't verify something in the cloud (feel, touch input, iOS performance), build it, then
  add a question under "Needs device playtest" in docs/HANDOFF.md.
- Keep each change to one ROADMAP task id. Put new ideas under "Parking lot" in HANDOFF.md.

## End of every session
1. `make check` green (and `make sim` once it exists, if race code changed).
2. Update docs/HANDOFF.md: status checkboxes, what changed, next steps, playtest questions.
3. Log non-obvious choices in docs/DECISIONS.md (date, decision, why).
4. Commit with the task id in the message, e.g. `M2.2: AI lane offsets`. Push.
