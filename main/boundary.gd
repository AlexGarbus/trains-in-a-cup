extends Area3D


signal train_entered


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("trains"):
		train_entered.emit()
		body.queue_free()
