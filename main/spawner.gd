extends Node


signal spawned(trains: Array[RigidBody3D])

@export_range(2, 100, 1, "or_greater") var min_length := 2
@export_range(3, 100, 1, "or_greater") var max_length := 6
@export_range(0.0, 100.0, 0.001, "or_greater", "hide_slider") var spacing := 16.0

@export_group("Spawnable Scenes")
@export var front_trains: Array[PackedScene]
@export var middle_trains: Array[PackedScene]
@export var rear_trains: Array[PackedScene]

@onready var spawn_points: Array[Node3D] = [$LeftSpawn, $RightSpawn]
@onready var timer := $SpawnTimer

var waiting_trains: Array[RigidBody3D]


func spawn_trains() -> void:
	var length := randi_range(min_length, max_length)
	var transform: Transform3D = spawn_points.pick_random().transform
	waiting_trains.append(_spawn_train(front_trains.pick_random(), transform))
	for i in range(1, length):
		transform = transform.translated_local(Vector3.FORWARD * spacing)
		var scene: PackedScene = middle_trains.pick_random()
		if i == length - 1:
			if i > 1 and randi_range(0, 1) == 0:
				break
			else:
				scene = rear_trains.pick_random()
		waiting_trains.append(_spawn_train(scene, transform, waiting_trains[i - 1]))
	waiting_trains[-1].disable_joint()
	spawned.emit(waiting_trains)


func _spawn_train(
	scene: PackedScene,
	transform: Transform3D,
	previous: RigidBody3D = null
) -> RigidBody3D:
	var train: RigidBody3D = scene.instantiate()
	train.transform = transform
	$"..".add_child(train)
	if previous:
		previous.attach_train(train)
	train.dropped.connect(_on_train_dropped)
	return train


func _on_train_dropped() -> void:
	for train in waiting_trains:
		train.dropped.disconnect(_on_train_dropped)
	waiting_trains.clear()
	timer.start()


func _on_spawn_timer_timeout() -> void:
	spawn_trains()


func _on_main_play_state_entered() -> void:
	timer.start()


func _on_main_end_state_entered() -> void:
	for train in waiting_trains:
		train.set_freeze(false)
	waiting_trains.clear()
	timer.stop()
