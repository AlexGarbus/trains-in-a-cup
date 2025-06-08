extends Control


@onready var quit_button := %QuitButton


func _ready() -> void:
	if OS.get_name() == "Web":
		quit_button.hide()


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_back_button_pressed() -> void:
	hide()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
