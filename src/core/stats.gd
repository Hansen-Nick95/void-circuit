class_name Stats
extends RefCounted
## Pure stat math. Adds apply first, then multipliers; same input, same output.

## Every stat a mod may touch. Data tests reject anything else, which catches typos in .tres files.
const KNOWN := [
	&"top_speed",
	&"acceleration",
	&"steer_rate",
	&"hull_max",
	&"boost_duration",
	&"boost_fill_rate",
	&"credit_gain",
]


static func compute(base: Dictionary, mods: Array[ModDef]) -> Dictionary:
	var adds: Dictionary = {}
	var mults: Dictionary = {}
	for m: ModDef in mods:
		for s: StatMod in m.stat_mods:
			if s.op == StatMod.Op.ADD:
				adds[s.stat] = adds.get(s.stat, 0.0) + s.value
			else:
				mults[s.stat] = mults.get(s.stat, 1.0) * s.value
	var out: Dictionary = {}
	for key: StringName in base:
		out[key] = (base[key] + adds.get(key, 0.0)) * mults.get(key, 1.0)
	return out
