extends CanvasLayer


@onready var title := $Title


func _on_main_play_state_started() -> void:
	title.visible = false
