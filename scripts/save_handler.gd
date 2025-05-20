class_name SaveHandler extends Resource

const SAVE_FILE_PATH: String = "user://record.bin"


static func save_data(data: SaveData) -> void:
	var file: FileAccess = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if not file.is_open():
		push_error(error_string(ERR_FILE_CANT_OPEN))
		return

	file.store_32(data.players_count)
	file.store_32(data.minutes_spent)
	file.store_32(data.minutes_goal)


static func load_data() -> SaveData:
	var data: SaveData = SaveData.new()

	if not FileAccess.file_exists(SAVE_FILE_PATH):
		push_error(error_string(ERR_FILE_NOT_FOUND))
		return data

	var file: FileAccess = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if not file.is_open():
		push_error(error_string(ERR_FILE_CANT_OPEN))
		return data

	data.players_count = file.get_32()
	data.minutes_spent = file.get_32()
	data.minutes_goal = file.get_32()

	return data
