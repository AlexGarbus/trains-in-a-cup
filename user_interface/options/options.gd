extends Control


const DEMO_ARGUMENT := "demo"

@onready var fullscreen_button := %FullscreenButton
@onready var quit_button := %QuitButton
@onready var leaderboard := %Leaderboard


func _ready() -> void:
	if OS.get_name() == "Web" or _is_demo():
		fullscreen_button.hide()
		quit_button.hide()


func set_records(chain: Array[ScoreRecord], individual: Array[ScoreRecord]) -> void:
	leaderboard.set_records(chain, individual)


func _is_demo() -> bool:
	for arg in OS.get_cmdline_user_args():
		if arg.trim_prefix("--") == DEMO_ARGUMENT:
			return true
	return false


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_back_button_pressed() -> void:
	hide()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
