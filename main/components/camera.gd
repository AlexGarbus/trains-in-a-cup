extends Camera3D


@export var move_duration := 1.0

@onready var title_marker := %CameraMarker1
@onready var play_marker := %CameraMarker2


func _ready() -> void:
	transform = title_marker.transform


func interpolate(weight: float, from: Transform3D, to: Transform3D) -> void:
	transform = from.interpolate_with(to, weight)


func interpolate_tween(from: Transform3D, to: Transform3D) -> void:
	var tween = create_tween()
	tween.tween_method(interpolate.bind(from, to), 0.0, 1.0, move_duration)


func _on_main_play_state_entered() -> void:
	interpolate_tween(title_marker.transform, play_marker.transform)


func _on_main_title_state_entered() -> void:
	interpolate_tween(play_marker.transform, title_marker.transform)


func _on_main_end_state_entered() -> void:
	interpolate_tween(play_marker.transform, title_marker.transform)
