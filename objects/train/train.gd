extends RigidBody3D


enum Type {
	STEAM,
	DIESEL,
	CABOOSE,
	BOX,
	TANK
}

enum State { WAIT, DRAG, FALL, DESTROY }

@export var type: Type

@onready var joint := $Joint

var state := State.WAIT


func attach_train(other: RigidBody3D) -> void:
	joint.node_b = other.get_path()


func disable_joint() -> void:
	joint.node_a = ""
	joint.node_b = ""
	joint.process_mode = Node.PROCESS_MODE_DISABLED


func _enter_drag_state() -> void:
	state = State.DRAG
	freeze = true


func _enter_fall_state() -> void:
	state = State.FALL
	freeze = false


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3,
	normal: Vector3, shape_idx: int
) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and state == State.WAIT:
			_enter_drag_state()
		elif event.is_released() and state == State.DRAG:
			_enter_fall_state()
	elif event is InputEventMouseMotion and state == State.DRAG:
		global_position = Vector3(
			event_position.x,
			global_position.y,
			event_position.z
		)
