class_name TrainBody
extends RigidBody3D


signal dropped

enum State {DRIVE, WAIT, DRAG, FALL}

@export var drive_distance := 10.0
@export var drive_duration := 1.0
@export var joint: PackedScene
@export var joint_offset: Vector3

var state := State.DRIVE
var front_train: TrainBody
var rear_train: TrainBody
var _drag_position: Vector3


func _ready() -> void:
	_enter_drive_state()


func _unhandled_input(event: InputEvent) -> void:
	if state == State.DRAG:
		if event is InputEventMouseButton and event.is_released():
			_call_on_all_trains("_drop", true)
			_enter_fall_state()
		elif event is InputEventMouseMotion:
			_drag_position = _mouse_to_world_position(event.position)


func _integrate_forces(physics_state: PhysicsDirectBodyState3D) -> void:
	if state == State.DRAG:
		physics_state.transform.origin = _drag_position


func set_freeze(value: bool) -> void:
	if value:
		_enter_wait_state()
	else:
		_enter_fall_state()


func get_length() -> int:
	var length := 1
	var current := front_train
	while current:
		length += 1
		current = current.front_train
	current = rear_train
	while current:
		length += 1
		current = current.rear_train
	return length


func attach_rear(other: TrainBody) -> void:
	rear_train = other
	other.front_train = self


func _enter_drive_state() -> void:
	state = State.DRIVE
	var final_position := global_position + global_transform.basis.z * drive_distance
	var tween := create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "position", final_position, drive_duration)
	tween.tween_callback(_spawn_joint)
	tween.tween_callback(_enter_wait_state)


func _enter_wait_state() -> void:
	state = State.WAIT


func _enter_drag_state(mouse_position := Vector2.ZERO) -> void:
	state = State.DRAG
	_drag_position = _mouse_to_world_position(mouse_position)
	_call_on_all_trains("_enter_fall_state")
	freeze = true


func _enter_fall_state() -> void:
	state = State.FALL
	freeze = false


func _drop() -> void:
	dropped.emit()


func _spawn_joint() -> void:
	if not rear_train:
		return
	var joint_scene: TrainJoint = joint.instantiate()
	joint_scene.transform = transform
	joint_scene.position = to_global(joint_offset)
	$"..".add_child(joint_scene)
	joint_scene.node_a = joint_scene.get_path_to(self)
	joint_scene.node_b = joint_scene.get_path_to(rear_train)
	joint_scene.destroy_on_train_exiting(self)
	joint_scene.destroy_on_train_exiting(rear_train)


func _call_on_all_trains(method: StringName, include_self := false) -> void:
	if include_self:
		call(method)
	var current := front_train
	while current:
		current.call(method)
		current = current.front_train
	current = rear_train
	while current:
		current.call(method)
		current = current.rear_train


func _mouse_to_world_position(mouse_position: Vector2) -> Vector3:
	var camera := get_viewport().get_camera_3d()
	var ray_origin := camera.project_ray_origin(mouse_position)
	var ray_direction := camera.project_ray_normal(mouse_position)
	var intersect_position: Vector3 = Plane(Vector3.UP).intersects_ray(
		ray_origin,
		ray_direction
	)
	return intersect_position + Vector3.UP * global_position.y


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3,
	normal: Vector3, shape_idx: int
) -> void:
	if event is InputEventMouseButton and event.is_pressed() and state == State.WAIT:
		_enter_drag_state(event.position)
