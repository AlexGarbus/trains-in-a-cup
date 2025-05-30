extends Control


signal start_pressed
signal options_pressed

@onready var score_label := $ScoreLabel
@onready var score_text: String = score_label.text


func set_score(chain_count: int, individual_count: int) -> void:
	score_label.text = score_text % [str(chain_count), str(individual_count)]


func _on_start_button_pressed() -> void:
	start_pressed.emit()


func _on_options_button_pressed() -> void:
	options_pressed.emit()
