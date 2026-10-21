extends GutTest


func _sequence(rng: SeededRng, count: int) -> Array[float]:
	var out: Array[float] = []
	for i: int in count:
		out.append(rng.next_float())
	return out


func test_same_seed_same_sequence() -> void:
	assert_eq(_sequence(SeededRng.new(1234), 20), _sequence(SeededRng.new(1234), 20))


func test_different_seeds_differ() -> void:
	assert_ne(_sequence(SeededRng.new(1), 20), _sequence(SeededRng.new(2), 20))


func test_fork_ignores_parent_consumption() -> void:
	var fresh := SeededRng.new(99)
	var used := SeededRng.new(99)
	_sequence(used, 50)
	assert_eq(_sequence(fresh.fork("map"), 10), _sequence(used.fork("map"), 10))


func test_forks_with_different_salts_differ() -> void:
	var rng := SeededRng.new(99)
	assert_ne(_sequence(rng.fork("map"), 10), _sequence(rng.fork("draft"), 10))


func test_range_int_is_inclusive() -> void:
	var rng := SeededRng.new(7)
	var seen := {}
	for i: int in 500:
		seen[rng.range_int(1, 3)] = true
	assert_eq(seen.keys().size(), 3)
	assert_has(seen, 1)
	assert_has(seen, 3)


func test_weighted_index_never_picks_zero_weight() -> void:
	var rng := SeededRng.new(5)
	var weights: Array[float] = [0.0, 1.0, 0.0, 3.0]
	var counts := [0, 0, 0, 0]
	for i: int in 2000:
		counts[rng.weighted_index(weights)] += 1
	assert_eq(counts[0], 0)
	assert_eq(counts[2], 0)
	# Expect roughly 1:3; allow wide slack so the test is not brittle.
	assert_between(float(counts[3]) / counts[1], 2.2, 4.0)
