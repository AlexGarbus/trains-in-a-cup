extends Node


@export_range(0.0, 100.0, 0.001, "or_greater", "hide_slider")
var min_body_speed := 5.0
@export_range(0.0, 100.0, 0.001, "or_greater", "hide_slider")
var max_body_speed := 200.0	
@export_range(-80.0, 24.0)
var min_impact_volume := 0.0
@export_range(-80.0, 24.0)
var max_impact_volume := 16.0
@export_range(0.0, 100.0, 0.001, "or_greater", "hide_slider")
var min_impact_pitch := 0.9
@export_range(0.0, 100.0, 0.001, "or_greater", "hide_slider")
var max_impact_pitch := 1.1


@onready var train := $".."
@onready var destroy_timer := $DestroyTimer
@onready var min_playback_timer := $MinPlaybackTimer
@onready var impact := $Impact

var _destroy_on_impact_finished := false


func _play_impact(body_speed: float) -> void:
	if (
		not min_playback_timer.is_stopped()
		or body_speed < min_body_speed
		or body_speed > max_body_speed
	):
		return
	var volume := remap(
		body_speed,
		min_body_speed,
		max_body_speed,
		min_impact_volume,
		max_impact_volume
	)
	impact.volume_db = volume
	impact.pitch_scale = randf_range(min_impact_pitch, max_impact_pitch)
	impact.play()
	min_playback_timer.start()


func _on_body_entered(body: Node) -> void:
	var rigid_body := body as RigidBody3D
	if not rigid_body or rigid_body.freeze:
		rigid_body = train
	if not rigid_body == train.front_train:
		_play_impact(rigid_body.linear_velocity.length())


func _on_dropped() -> void:
	destroy_timer.start()


func _on_destroy_timer_timeout() -> void:
	if impact.playing:
		_destroy_on_impact_finished = true
	else:
		queue_free()


func _on_impact_finished() -> void:
	if _destroy_on_impact_finished:
		queue_free()
