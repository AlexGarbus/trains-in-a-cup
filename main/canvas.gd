extends CanvasLayer


@onready var title := $Title
@onready var end := $End


func _on_main_play_state_entered() -> void:
	title.hide()
	end.hide()


func _on_main_end_state_entered() -> void:
	end.show()
