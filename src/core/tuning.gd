class_name Tuning
extends Resource
## Every vehicle feel number. Tweak data/tuning.tres, never literals in scripts.
## Starting values are guesses; M1 tunes them on a real phone.

@export_group("Hover")
@export var hover_height: float = 1.2
@export var hover_stiffness: float = 40.0
@export var align_speed: float = 8.0

@export_group("Drive")
## Metres per second.
@export var top_speed: float = 60.0
@export var acceleration: float = 25.0
@export var drag: float = 0.6
## Radians per second at full steer.
@export var steer_rate: float = 2.2

@export_group("Drift")
@export var drift_steer_mult: float = 1.6
@export var drift_grip: float = 0.35
## Boost meter gained per second of drifting (meter is 0..1).
@export var drift_boost_per_second: float = 0.25

@export_group("Boost")
@export var boost_speed_mult: float = 1.35
@export var boost_drain_per_second: float = 0.5

@export_group("Hull")
@export var start_hull: int = 5
## Seconds after a wall scrape before another scrape can deal damage.
@export var scrape_cooldown: float = 0.75
