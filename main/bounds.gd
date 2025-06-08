extends Node


signal play_bound_entered(train: TrainBody)

@onready var play_bound := $PlayBound
@onready var end_bound := $EndBound

var _is_play_bound_entered := true


func _on_play_bound_body_entered(body: Node3D) -> void:
	if not _is_play_bound_entered and body.is_in_group("trains"):
		play_bound_entered.emit(body)
		_is_play_bound_entered = true
		play_bound.set_deferred("monitoring", false)


func _on_end_bound_body_entered(body: Node3D) -> void:
	if body.is_in_group("trains"):
		body.queue_free()


func _on_main_play_state_entered() -> void:
	_is_play_bound_entered = false
	play_bound.set_deferred("monitoring", true)
