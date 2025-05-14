extends Node


var chain_count := 0
var individual_count := 0
var waiting_trains: Array[RigidBody3D]


func reset_points() -> void:
	individual_count = 0
	chain_count = 0


func _on_train_dropped() -> void:
	for train in waiting_trains:
		train.disconnect("dropped", _on_train_dropped)
		individual_count += 1
	waiting_trains.clear()
	chain_count += 1


func _on_spawner_spawned(trains: Array[RigidBody3D]) -> void:
	waiting_trains = trains.duplicate()
	for train in trains:
		train.connect("dropped", _on_train_dropped)


func _on_bounds_play_bound_entered(train: RigidBody3D) -> void:
	waiting_trains.clear()
	chain_count -= 1
	individual_count -= train.get_length()


func _on_main_play_state_entered() -> void:
	reset_points()
