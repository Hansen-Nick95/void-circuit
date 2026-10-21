extends GutTest
## Validates every content file so typos in .tres data fail CI instead of failing at runtime.

const MODS_DIR := "res://data/mods"


func _mod_paths() -> Array[String]:
	var out: Array[String] = []
	for file: String in DirAccess.get_files_at(MODS_DIR):
		if file.ends_with(".tres"):
			out.append(MODS_DIR.path_join(file))
	return out


func test_mods_dir_is_not_empty() -> void:
	assert_gt(_mod_paths().size(), 0)


func test_every_mod_is_valid() -> void:
	var ids := {}
	for path: String in _mod_paths():
		var mod := load(path) as ModDef
		assert_not_null(mod, "%s should load as ModDef" % path)
		if mod == null:
			continue
		assert_eq(
			String(mod.id), path.get_file().get_basename(), "%s: id must match filename" % path
		)
		assert_false(ids.has(mod.id), "%s: duplicate id %s" % [path, mod.id])
		ids[mod.id] = true
		assert_ne(mod.display_name, "", "%s: display_name is empty" % path)
		assert_gt(mod.tags.size(), 0, "%s: needs at least one tag" % path)
		for s: StatMod in mod.stat_mods:
			assert_has(Stats.KNOWN, s.stat, "%s: unknown stat %s" % [path, s.stat])


func test_tuning_loads_with_sane_values() -> void:
	var tuning := load("res://data/tuning.tres") as Tuning
	assert_not_null(tuning)
	assert_gt(tuning.top_speed, 0.0)
	assert_gt(tuning.start_hull, 0)
	assert_gt(tuning.boost_speed_mult, 1.0)
