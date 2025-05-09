extends RigidBody3D


signal dropped

enum State {DRIVE, WAIT, DRAG, FALL, DESTROY}

@export var drive_distance := 10.0
@export var drive_duration := 1.0

@onready var joint := $Joint

var state := State.DRIVE

var front_train: RigidBody3D
var rear_train: RigidBody3D


func _ready() -> void:
	_enter_drive_state()


func _unhandled_input(event: InputEvent) -> void:
	if state == State.DRAG:
		if event is InputEventMouseButton and event.is_released():
			dropped.emit()
			_enter_fall_state()
		elif event is InputEventMouseMotion:
			_move_to_mouse(event)


func attach_train(other: RigidBody3D) -> void:
	joint.node_b = other.get_path()
	rear_train = other
	other.front_train = self


func disable_joint() -> void:
	joint.node_a = ""
	joint.node_b = ""
	joint.process_mode = Node.PROCESS_MODE_DISABLED


func _enter_drive_state() -> void:
	state = State.DRIVE
	var final_position := global_position + global_transform.basis.z * drive_distance
	var tween := create_tween()
	tween.tween_property(self, "position", final_position, drive_duration)
	tween.tween_callback(_enter_wait_state)


func _enter_wait_state() -> void:
	state = State.WAIT


func _enter_drag_state() -> void:
	state = State.DRAG
	_call_on_all_trains("_enter_fall_state")
	freeze = true


func _enter_fall_state() -> void:
	state = State.FALL
	freeze = false


func _call_on_all_trains(method: StringName, include_self := false) -> void:
	if include_self:
		call(method)
	var first := front_train
	var last := rear_train
	while first:
		first.call(method)
		first = first.front_train
	while last:
		last.call(method)
		last = last.rear_train


func _move_to_mouse(event: InputEventMouseMotion) -> void:
	var camera := get_viewport().get_camera_3d()
	var ray_origin := camera.project_ray_origin(event.position)
	var ray_direction := camera.project_ray_normal(event.position)
	var intersect_position: Vector3 = Plane(Vector3.UP).intersects_ray(
		ray_origin,
		ray_direction
	)
	global_position = intersect_position + Vector3.UP * global_position.y


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3,
	normal: Vector3, shape_idx: int
) -> void:
	if event is InputEventMouseButton and event.is_pressed() and state == State.WAIT:
		_enter_drag_state()
