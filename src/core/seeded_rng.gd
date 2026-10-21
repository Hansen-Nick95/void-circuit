class_name SeededRng
extends RefCounted
## Deterministic random stream: the same seed always yields the same sequence.
## Game code gets streams from the Rng autoload; tests build them directly.

var seed_value: int:
	get:
		return _seed

var _seed: int
var _rng := RandomNumberGenerator.new()


func _init(new_seed: int = 0) -> void:
	_seed = new_seed
	_rng.seed = new_seed


## Float in [0, 1).
func next_float() -> float:
	return _rng.randf()


func range_float(from: float, to: float) -> float:
	return _rng.randf_range(from, to)


## Integer in [from, to], inclusive on both ends.
func range_int(from: int, to: int) -> int:
	return _rng.randi_range(from, to)


## Random element of a non-empty array.
func pick(items: Array) -> Variant:
	assert(not items.is_empty(), "pick() needs a non-empty array")
	return items[_rng.randi_range(0, items.size() - 1)]


## Index chosen with probability proportional to its weight. Zero weights never win.
func weighted_index(weights: Array[float]) -> int:
	var total := 0.0
	for w: float in weights:
		total += maxf(w, 0.0)
	assert(total > 0.0, "weighted_index() needs at least one positive weight")
	var roll := _rng.randf() * total
	for i: int in weights.size():
		var w := maxf(weights[i], 0.0)
		if w > 0.0 and roll < w:
			return i
		roll -= w
	# Float rounding can leave roll == total; fall back to the last positive weight.
	for i: int in range(weights.size() - 1, -1, -1):
		if weights[i] > 0.0:
			return i
	return -1


## Independent child stream for one subsystem (map gen, drafts, AI...). It depends only on
## this stream's seed and the salt, so one subsystem consuming numbers never shifts another.
func fork(salt: String) -> SeededRng:
	return SeededRng.new(hash("%d:%s" % [_seed, salt]))
