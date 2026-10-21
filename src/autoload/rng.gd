extends Node
## The only source of randomness in the game. Call start_run() once per run, then ask for a
## named stream per subsystem. Never call randf()/randi() directly.

var run: SeededRng = SeededRng.new(0)


func start_run(seed_value: int) -> void:
	run = SeededRng.new(seed_value)


func stream(salt: String) -> SeededRng:
	return run.fork(salt)
