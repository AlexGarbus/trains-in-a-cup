extends Node


@export_range(0.0, 100.0, 0.001, "or_greater", "hide_slider")
var min_impact_speed := 100.0
@export_range(0.0, 100.0, 0.001, "or_greater", "hide_slider")
var max_impact_speed := 1000.0
@export_range(-80.0, 24.0)
var min_impact_volume := 0.0
@export_range(-80.0, 24.0)
var max_impact_volume := 16.0
@export_range(0.0, 100.0, 0.001, "or_greater", "hide_slider")
var min_impact_pitch := 0.9
@export_range(0.0, 100.0, 0.001, "or_greater", "hide_slider")
var max_impact_pitch := 1.1

@onready var destroy_timer := $DestroyTimer
@onready var impact := $Impact


func _play_impact(speed: float) -> void:
	if speed < min_impact_speed:
		return
	var volume := remap(
		max(speed, max_impact_speed),
		min_impact_speed,
		max_impact_speed,
		min_impact_volume,
		max_impact_volume
	)
	impact.volume_db = volume
	impact.pitch_scale = randf_range(min_impact_pitch, max_impact_pitch)
	impact.play()


func _on_body_entered(body: Node) -> void:
	var rigidbody := body as RigidBody3D
	if rigidbody:
		_play_impact(rigidbody.linear_velocity.length())


func _on_fell() -> void:
	destroy_timer.start()


func _on_destroy_timer_timeout() -> void:
	queue_free()
