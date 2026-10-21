extends Node
## Global signal hub. Systems emit and listen here instead of holding references to each
## other across scenes. Mod hooks (on_drift_end, on_collision, ...) subscribe to these.

@warning_ignore_start("unused_signal")

signal race_started(track_id: StringName)
signal race_finished(placement: int)
signal vehicle_collided(damage: int)
signal drift_ended(duration: float)
signal overtake
signal event_finished(event_id: StringName)

@warning_ignore_restore("unused_signal")
