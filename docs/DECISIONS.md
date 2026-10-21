# Decisions

Short log of choices and why. Newest at the bottom. Don't reopen a decision without a new reason.

## 2026-10-21: Godot 4 with GDScript
Godot stores scenes, resources and settings as plain text, so Claude can edit and diff them. It also
runs tests headless on Linux with no GPU or license, which makes the cloud-session + CI harness possible.
It's free (MIT) with no royalties, has built-in physics, particles, glow and Path3D track tools, and
exports to iOS through Xcode with a Metal renderer.
- Rejected **Unity 6**: editor-centric YAML scenes, license activation for headless CI, licensing history.
- Rejected **Babylon.js + Capacitor** (the runner-up): we'd build more engine ourselves, and the iOS WebView
  caps performance and adds input latency.
- Rejected **SceneKit/RealityKit**: SceneKit was deprecated in 2025, and RealityKit targets AR.
- GDScript rather than C#: C# export to iOS is still experimental in Godot 4.

## 2026-10-21: Pinned Godot 4.7.2-stable
The newest stable release at repo creation. The pin lives in `.godot-version`. Bump it deliberately and
log the bump here.

## 2026-10-21: Hull bar (5 pips) instead of one-wreck-ends-run
Touch steering is less precise than a controller. A one-wreck mode can return as a high Heat level.

## 2026-10-21: Hover craft only, arcade physics
No wheels and no realistic physics. The `CharacterBody3D` hover controller is driven by `Tuning` values,
so feel is predictable and tunable on device.

## 2026-10-21: Rules in src/core, nodes thin
Pure RefCounted/Resource classes hold the game rules so they can be unit tested headless and run under a
seed. Node scripts only wire input, rendering and signals.

## 2026-10-21: Randomness via named forked streams
`Rng.stream("map")` forks from the run seed by name, so one subsystem consuming numbers never shifts
another. Runs replay exactly from their seed, which tests, the balance sim and daily challenges rely on.

## 2026-10-21: GUT vendored, gdtoolkit pinned to 4.5.0
GUT 9.7.1 is committed under `addons/gut` so there's no download step. gdtoolkit is pinned exactly so
formatting is identical on the Mac, in the cloud and in CI.

## 2026-10-21: Landscape orientation, no weapons in v1
Landscape suits racing. Combat items are in the parking lot until the core loop is proven fun.
