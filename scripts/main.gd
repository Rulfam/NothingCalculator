class_name MainWindow extends Control

const SAVE_FILE_PATH: String = "user://record.bin"

@export var input_handler: InputHandler

var data: SaveData = SaveData.new()

@onready var rate_label: Label = $VBox/Displays/Rate/Number
@onready var time_label: Label = $VBox/Displays/TimeLeft/Number


func _ready() -> void:
	if not (input_handler is InputHandler):
		push_error("Main: Input handler is not set!")
		return

	restore()


func update_stats_panel() -> void:
	# Calculating time that's left

	var minutes_left: int = data.minutes_goal - data.minutes_spent
	if 0 < data.players_count:
		minutes_left /= data.players_count

	# Settings the display panel labels

	var f_rate: String = tr(&"FMT.RATE") \
		.format({"0": "%.2f" % (60.0 / data.players_count)})
	var f_time: String = tr(&"FMT.TIME") \
		.format({
			"w": int(minutes_left / 10080.0),
			"d": int(minutes_left / 1440.0) % 7,
			"h": int(minutes_left / 60.0) % 24,
			"m": int(minutes_left) % 60})

	rate_label.text = f_rate if data.players_count > 0 else "FMT.INVALID"
	time_label.text = f_time if minutes_left > 0 else "FMT.INVALID"


func calculate() -> void:
	data = input_handler.read_inputs()
	update_stats_panel()
	SaveHandler.save_data(data)


func restore() -> void:
	data = SaveHandler.load_data()
	update_stats_panel()
	input_handler.fill_inputs(data)


func _on_calculate_button_pressed() -> void:
	calculate()


func _on_clear_button_pressed() -> void:
	input_handler.clear_inputs()


func _on_restore_button_pressed() -> void:
	restore()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
