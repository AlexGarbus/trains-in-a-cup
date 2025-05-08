extends CanvasLayer


@onready var title := $Title


func _on_main_play_state_entered() -> void:
	title.visible = false
