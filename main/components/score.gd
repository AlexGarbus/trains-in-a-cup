extends Node


signal finalized(chain_count: int, individual_count: int)

var chain_count := 0
var individual_count := 0
var waiting_trains: Array[TrainBody]


func reset_points() -> void:
	chain_count = 0
	individual_count = 0


func _on_train_dropped() -> void:
	for train in waiting_trains:
		train.disconnect("dropped", _on_train_dropped)
		individual_count += 1
	waiting_trains.clear()
	chain_count += 1


func _on_spawner_spawned(trains: Array[TrainBody]) -> void:
	waiting_trains = trains.duplicate()
	for train in trains:
		train.connect("dropped", _on_train_dropped)


func _on_bounds_play_bound_entered(train: TrainBody) -> void:
	waiting_trains.clear()
	chain_count -= 1
	individual_count -= train.get_length()
	finalized.emit(chain_count, individual_count)


func _on_main_play_state_entered() -> void:
	reset_points()
