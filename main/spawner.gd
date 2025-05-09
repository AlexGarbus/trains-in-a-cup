extends Node


@export_range(2, 100, 1, "or_greater") var min_length := 2
@export_range(3, 100, 1, "or_greater") var max_length := 6
@export_range(0.0, 100.0, 1.0, "or_greater", "hide_slider") var spacing := 16.0

@export_group("Spawnable Scenes")
@export var front_trains: Array[PackedScene]
@export var middle_trains: Array[PackedScene]
@export var rear_trains: Array[PackedScene]

@onready var spawn_points: Array[Node3D] = [$LeftSpawn, $RightSpawn]
@onready var timer := $SpawnTimer


func spawn_trains() -> void:
	var length := randi_range(min_length, max_length)
	var transform: Transform3D = spawn_points.pick_random().transform
	var current_train := _spawn_train(front_trains.pick_random(), transform)
	var previous_train: RigidBody3D
	for i in range(0, length):
		transform = transform.translated_local(Vector3.FORWARD * spacing)
		var train_scene: PackedScene = middle_trains.pick_random()
		if i == length - 1:
			if randi_range(0, 1) == 0:
				break
			else:
				train_scene = rear_trains.pick_random()
		previous_train = current_train
		current_train = _spawn_train(train_scene, transform, previous_train)
	current_train.disable_joint()


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
	return train


func _on_spawn_timer_timeout() -> void:
	spawn_trains()


func _on_main_play_state_entered() -> void:
	timer.start()
