extends GutTest


func _mod(stat: StringName, op: StatMod.Op, value: float) -> ModDef:
	var s := StatMod.new()
	s.stat = stat
	s.op = op
	s.value = value
	var m := ModDef.new()
	m.stat_mods.append(s)
	return m


func test_no_mods_returns_base() -> void:
	var base := {&"top_speed": 100.0}
	var mods: Array[ModDef] = []
	assert_eq(Stats.compute(base, mods), base)


func test_adds_apply_before_multipliers() -> void:
	var base := {&"top_speed": 100.0}
	var mods: Array[ModDef] = [
		_mod(&"top_speed", StatMod.Op.MULTIPLY, 1.1),
		_mod(&"top_speed", StatMod.Op.ADD, 20.0),
	]
	assert_almost_eq(Stats.compute(base, mods)[&"top_speed"], 132.0, 0.001)


func test_multipliers_stack_multiplicatively() -> void:
	var base := {&"top_speed": 100.0}
	var mods: Array[ModDef] = [
		_mod(&"top_speed", StatMod.Op.MULTIPLY, 1.1),
		_mod(&"top_speed", StatMod.Op.MULTIPLY, 1.1),
	]
	assert_almost_eq(Stats.compute(base, mods)[&"top_speed"], 121.0, 0.001)


func test_mods_for_absent_stats_are_ignored() -> void:
	var base := {&"top_speed": 100.0}
	var mods: Array[ModDef] = [_mod(&"hull_max", StatMod.Op.ADD, 1.0)]
	assert_eq(Stats.compute(base, mods), base)
