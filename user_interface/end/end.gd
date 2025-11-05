extends Control


signal start_pressed
signal options_pressed
signal name_submitted(record_name: String)

@onready var score_label := $ScoreLabel
@onready var score_text: String = score_label.text
@onready var leaderboard := %Leaderboard
@onready var line_edit := %LineEdit
@onready var menu_container := %Menu
@onready var name_entry_container := %NameEntry
@onready var leaderboard_container := %LeaderboardPanel


func _ready() -> void:
	menu_container.hide()
	name_entry_container.hide()
	leaderboard_container.hide()


func set_score(chain_count: int, individual_count: int) -> void:
	score_label.text = score_text % [str(chain_count), str(individual_count)]


func set_records(chain: Array[ScoreRecord], individual: Array[ScoreRecord]) -> void:
	leaderboard.set_records(chain, individual)


func _on_start_button_pressed() -> void:
	leaderboard_container.hide()
	start_pressed.emit()


func _on_options_button_pressed() -> void:
	options_pressed.emit()


func _on_submit_name_button_pressed() -> void:
	name_submitted.emit(line_edit.text)
	menu_container.show()
	name_entry_container.hide()
	leaderboard_container.show()


func _on_read_write_data_updated(awaiting_name: bool) -> void:
	menu_container.visible = not awaiting_name
	name_entry_container.visible = awaiting_name
