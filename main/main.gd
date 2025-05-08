extends Node


signal title_state_entered
signal play_state_entered
signal end_state_entered

enum GameState {TITLE, PLAY, END}

var game_state = GameState.TITLE: set = _set_game_state


func _set_game_state(value: GameState) -> void:
	game_state = value
	match value:
		GameState.TITLE:
			title_state_entered.emit()
		GameState.PLAY:
			play_state_entered.emit()
		GameState.END:
			end_state_entered.emit()


func _on_title_start_pressed() -> void:
	if game_state == GameState.TITLE:
		game_state = GameState.PLAY
