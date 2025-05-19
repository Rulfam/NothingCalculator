class_name MainWindow extends Control

const DAYS_GOAL: int = 12 * 7
const SAVE_FILE_PATH: String = "user://record.bin"

var players_count: int = 1
var minutes_spent: int = 0

@onready var days_input: LineEdit = $VBox/Inputs/Time/Fields/Days
@onready var hours_input: LineEdit = $VBox/Inputs/Time/Fields/Hours
@onready var minutes_input: LineEdit = $VBox/Inputs/Time/Fields/Minutes
@onready var players_input: LineEdit = $VBox/Inputs/Players/Field

@onready var rate_label: Label = $VBox/Displays/Rate/Number
@onready var time_label: Label = $VBox/Displays/TimeLeft/Number


func _ready() -> void:
	load_data()


func update_stats_panel() -> void:
	# Calculating time that's left

	var minutes_left: int = DAYS_GOAL * 1440 - minutes_spent
	if 0 < players_count:
		minutes_left /= players_count

	var days := int(minutes_left / 1_440.0)
	var hours := int(minutes_left / 60.0) % 24
	var minutes := int(minutes_left) % 60

	# Settings the display panel labels

	var f_rate: String = tr("^FORMAT.RATE") \
		.format({"0": "%.2f" % (60.0 / players_count)})
	var f_time: String = tr("^FORMAT.TIME") \
		.format({"d": days, "h": hours, "m": minutes})

	rate_label.text = f_rate if players_count > 0 else "^FORMAT.INVALID"
	time_label.text = f_time if minutes_left > 0 else "^FORMAT.INVALID"


func fill_inputs() -> void:
	players_input.text = str(players_count)
	days_input.text = str(int(minutes_spent / 1_440.0))
	hours_input.text = str(int(minutes_spent / 60.0) % 24)
	minutes_input.text = str(minutes_spent % 60)


func read_inputs() -> void:
	players_count = int(players_input.text)
	minutes_spent = \
			int(days_input.text) * 1440 \
			+ int(hours_input.text) * 60 \
			+ int(minutes_input.text)


func save_data() -> void:
	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file.is_open():
		file.store_8(players_count)
		file.store_32(minutes_spent)


func load_data() -> void:
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		players_count = file.get_8()
		minutes_spent = file.get_32()
	update_stats_panel()
	fill_inputs()


func _on_clear_button_pressed() -> void:
	players_input.clear()
	days_input.clear()
	hours_input.clear()
	minutes_input.clear()


func _on_restore_button_pressed() -> void:
	load_data()


func _on_calculate_button_pressed() -> void:
	read_inputs()
	update_stats_panel()
	save_data()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
