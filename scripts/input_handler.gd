class_name InputHandler extends Node

@export var players_input: LineEdit

@export_group("Time Goal Inputs")
@export var weeks_goal: LineEdit
@export var days_goal: LineEdit
@export var hours_goal: LineEdit
@export var minutes_goal: LineEdit

@export_group("Time Spent Inputs")
@export var weeks_spent: LineEdit
@export var days_spent: LineEdit
@export var hours_spent: LineEdit
@export var minutes_spent: LineEdit


func _ready() -> void:
	if not (players_input is LineEdit
			and weeks_goal is LineEdit
			and days_goal is LineEdit
			and hours_goal is LineEdit
			and minutes_goal is LineEdit

			and weeks_spent is LineEdit
			and days_spent is LineEdit
			and hours_spent is LineEdit
			and minutes_spent is LineEdit):
		push_error("Input handler: Not all input fields are set!")
		return


func read_inputs() -> SaveData:
	var data: SaveData = SaveData.new()

	data.players_count = int(players_input.text)

	data.minutes_goal = \
			int(weeks_goal.text) * 10080 \
			+ int(days_goal.text) * 1440 \
			+ int(hours_goal.text) * 60 \
			+ int(minutes_goal.text)

	data.minutes_spent = \
			int(weeks_spent.text) * 10080 \
			+ int(days_spent.text) * 1440 \
			+ int(hours_spent.text) * 60 \
			+ int(minutes_spent.text)

	return data


func fill_inputs(data: SaveData) -> void:
	players_input.text = str(data.players_count)

	weeks_goal.text = str(int(data.minutes_goal / 10080.0))
	days_goal.text = str(int(data.minutes_goal / 1440.0) % 7)
	hours_goal.text = str(int(data.minutes_goal / 60.0) % 24)
	minutes_goal.text = str(data.minutes_goal % 60)

	weeks_spent.text = str(int(data.minutes_spent / 10080.0))
	days_spent.text = str(int(data.minutes_spent / 1440.0) % 7)
	hours_spent.text = str(int(data.minutes_spent / 60.0) % 24)
	minutes_spent.text = str(data.minutes_spent % 60)


func clear_inputs() -> void:
	players_input.clear()

	weeks_goal.clear()
	days_goal.clear()
	hours_goal.clear()
	minutes_goal.clear()

	weeks_spent.clear()
	days_spent.clear()
	hours_spent.clear()
	minutes_spent.clear()
