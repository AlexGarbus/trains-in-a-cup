extends Node


signal play_bound_entered(train: RigidBody3D)

@onready var play_bound := $PlayBound
@onready var end_bound := $EndBound


func _on_play_bound_body_entered(body: Node3D) -> void:
	if body.is_in_group("trains"):
		play_bound_entered.emit(body)
		play_bound.set_deferred("monitoring", false)


func _on_end_bound_body_entered(body: Node3D) -> void:
	if body.is_in_group("trains"):
		body.queue_free()


func _on_main_play_state_entered() -> void:
	play_bound.set_deferred("monitoring", true)
