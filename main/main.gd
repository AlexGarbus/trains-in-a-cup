extends Node


signal title_state_started
signal play_state_started
signal end_state_started

enum GameState {Title, Play, End}

var game_state = GameState.Title: set = _set_game_state


func _set_game_state(value: GameState) -> void:
	game_state = value
	match value:
		GameState.Title:
			title_state_started.emit()
		GameState.Play:
			play_state_started.emit()
		GameState.End:
			end_state_started.emit()


func _on_title_start_pressed() -> void:
	if game_state == GameState.Title:
		game_state = GameState.Play
