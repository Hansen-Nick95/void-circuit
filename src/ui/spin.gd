extends Node3D
## M0 placeholder: spins the stand-in ship on the title scene.

@export var degrees_per_second: float = 45.0


func _process(delta: float) -> void:
	rotate_y(deg_to_rad(degrees_per_second) * delta)
