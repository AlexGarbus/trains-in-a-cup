extends Node


signal play_bound_entered

@onready var play_bound := $PlayBound
@onready var end_bound := $EndBound


func _on_play_bound_body_entered(body: Node3D) -> void:
	if body.is_in_group("trains"):
		play_bound_entered.emit()
		play_bound.set_deferred("monitoring", false)


func _on_end_bound_body_entered(body: Node3D) -> void:
	if body.is_in_group("trains"):
		body.destroy_all(true)


func _on_main_play_state_entered() -> void:
	play_bound.set_deferred("monitoring", true)
