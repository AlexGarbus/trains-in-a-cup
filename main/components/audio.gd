extends Node


@onready var end := $End


func _on_main_end_state_entered() -> void:
	end.play()
