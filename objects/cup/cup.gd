extends Node3D


@export var flip_duration := 1.0
@export var flip_start_delay := 1.0
@export var flip_middle_delay := 2.0

@onready var flip_sound := $FlipSound

var _flip_tween: Tween


func play_flip() -> void:
	var tween := create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TransitionType.TRANS_BACK)
	tween.tween_interval(flip_start_delay)
	tween.tween_callback(flip_sound.play)
	tween.tween_property(self, "rotation_degrees", Vector3(0, 0, 180), flip_duration)
	tween.tween_interval(flip_middle_delay)
	tween.tween_property(self, "rotation_degrees", Vector3.ZERO, flip_duration)
	_flip_tween = tween


func _on_main_end_state_entered() -> void:
	play_flip()


func _on_main_play_state_entered() -> void:
	flip_sound.stop()
	if _flip_tween:
		_flip_tween.kill()
		rotation_degrees = Vector3.ZERO
