extends GutTest
## Boot smoke test: the main scene loads, enters the tree and survives a few frames.


func test_main_scene_boots() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	assert_not_null(packed)
	var main := packed.instantiate()
	add_child_autofree(main)
	await wait_process_frames(3)
	assert_not_null(main.get_node_or_null("Ship"))
	assert_not_null(main.get_node_or_null("Camera3D"))


func test_autoloads_are_registered() -> void:
	assert_not_null(get_tree().root.get_node_or_null("EventBus"))
	assert_not_null(get_tree().root.get_node_or_null("Rng"))
