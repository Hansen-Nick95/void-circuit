extends GutTest
## Every file under assets/ needs a row in assets/CREDITS.csv (path, source_url, license, author).

const ROOT := "res://assets"
const LEDGER := "res://assets/CREDITS.csv"
const IGNORED_EXTENSIONS := ["import", "uid", "gdignore"]


func _asset_files(dir: String) -> Array[String]:
	var out: Array[String] = []
	for file: String in DirAccess.get_files_at(dir):
		var path := dir.path_join(file)
		if path == LEDGER or file.get_extension() in IGNORED_EXTENSIONS:
			continue
		out.append(path.trim_prefix(ROOT + "/"))
	for sub: String in DirAccess.get_directories_at(dir):
		out.append_array(_asset_files(dir.path_join(sub)))
	return out


func _ledger_rows() -> Dictionary:
	var rows := {}
	var file := FileAccess.open(LEDGER, FileAccess.READ)
	assert_not_null(file, "assets/CREDITS.csv is missing")
	if file == null:
		return rows
	var header := file.get_csv_line()
	assert_eq(Array(header), ["path", "source_url", "license", "author"])
	while not file.eof_reached():
		var row := file.get_csv_line()
		if row.size() >= 3 and row[0] != "":
			rows[row[0]] = row
	return rows


func test_every_asset_is_credited() -> void:
	var rows := _ledger_rows()
	for path: String in _asset_files(ROOT):
		assert_has(rows, path, "assets/%s has no row in CREDITS.csv" % path)


func test_every_row_names_a_license() -> void:
	for row: PackedStringArray in _ledger_rows().values():
		assert_ne(row[2].strip_edges(), "", "%s: license column is empty" % row[0])
