extends MeshInstance3D


func _on_main_play_state_entered() -> void:
	show()


func _on_main_end_state_entered() -> void:
	hide()
