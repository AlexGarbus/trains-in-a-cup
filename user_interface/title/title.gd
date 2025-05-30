extends Control


signal start_pressed
signal options_pressed


func _on_start_button_pressed() -> void:
	start_pressed.emit()


func _on_options_button_pressed() -> void:
	options_pressed.emit()
