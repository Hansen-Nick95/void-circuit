# Roadmap

The milestones are in order, and each ends with something playable. Put the task id in commit messages
(`M1.4: thumb-zone steering`). Sizing assumes part-time evenings and is a rough guess.

## M0: Harness and toolchain (~1 week)
- M0.1 Repo, Godot project (Mobile renderer, landscape), .gitignore
- M0.2 Vendor GUT, gdtoolkit, Makefile, setup.sh, untyped = error
- M0.3 CI workflow green
- M0.4 CLAUDE.md, HANDOFF.md, DECISIONS.md, ROADMAP.md, GDD.md, MAC_SETUP.md
- M0.5 SessionStart hook + Claude cloud environment setup script
- M0.6 `make shots` renders frames (Linux via xvfb; macOS directly)
- M0.7 Blank build running on your iPhone (human, on the Mac)

**Done when:** `make check` is green in CI, in a cloud session and on the Mac, and a blank app launches on the phone.

## M1: Feel the ship (1–2 weeks)
- M1.1 Hover controller (raycast to track, align to normal, arcade accel and drag), driven by `Tuning`
- M1.2 Greybox test track: Path3D + CSGPolygon3D road and walls
- M1.3 Chase camera with speed-based FOV
- M1.4 Touch input (thumb zones, hold-both to drift, boost button) plus keyboard in the editor
- M1.5 Boost meter, drift charging boost
- M1.6 Debug HUD (speed, fps, drift state)

**Done when:** a lap on an empty track is fun on the phone.

## M2: Racing (~2 weeks)
- M2.1 Checkpoints, laps, race state machine (countdown → racing → finished)
- M2.2 AI racers on the curve with lookahead, lane offsets and skill
- M2.3 Positions and race HUD (place, lap, hull)
- M2.4 Collisions → hull damage, wreck sequence
- M2.5 Boost pads and repair orbs
- M2.6 `make sim`: headless AI-only races on fixed seeds; add it to CI

**Done when:** you can race 5 AI on 2 greybox tracks and the sim is green in CI.

## M3: The run (~2 weeks)
- M3.1 RunState (seed, hull, credits, mods, position on the map)
- M3.2 League map generator: 3 sectors, branching, seeded, tested
- M3.3 Event types: Race, Elimination, Time Trial, Duel, Garage, Repair, Mystery, Final
- M3.4 Draft screen: 1 of 3 picks, rarity and tag weighting
- M3.5 Mod hooks via EventBus, plus all 16 starter mods as .tres files
- M3.6 Run end screens (wreck / champion) and run summary
- M3.7 `make balance`: Monte Carlo of 1,000 seeded runs → reports/balance.md

**Done when:** a full 3-sector run is playable from start to finish.

## M4: Meta progression (1–2 weeks)
- M4.1 Versioned save system with migration tests
- M4.2 Salvage payout formula, checked against the balance report
- M4.3 Garage: Hangar, Workshop, Research
- M4.4 Pilot License (Heat levels)
- M4.5 Codex and run history

**Done when:** three runs in a row feel different and progress survives quitting the app.

## M5: Content and polish (2–3 weeks)
- M5.1 Replace greybox with Kenney and Quaternius art, fill in assets/CREDITS.csv
- M5.2 6 tracks across 3 themes (one per sector)
- M5.3 Music, engine audio that tracks speed, SFX
- M5.4 Effects: boost trails, speed lines, screen shake, wreck effect
- M5.5 UI skin, a 4-rival roster, grow the mod pool to 40
- M5.6 First-run tutorial race

**Done when:** someone who isn't you plays a full run without needing help.

## M6: Ship (1–2 weeks)
- M6.1 Performance pass on the oldest iPhone available (target 60 fps)
- M6.2 App icon, launch screen, store screenshots
- M6.3 App Store Connect listing, privacy label (no data collected), age rating
- M6.4 TestFlight with friends, fix pass, submit

**Done when:** the game is live on the App Store.
