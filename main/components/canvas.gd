extends CanvasLayer


@onready var title := $Title
@onready var end := $End
@onready var options := $Options


func set_records(chain: Array[ScoreRecord], individual: Array[ScoreRecord])-> void:
	if not is_node_ready():
		await ready
	end.set_records(chain, individual)
	options.set_records(chain, individual)


func _on_main_play_state_entered() -> void:
	title.hide()
	end.hide()


func _on_title_options_pressed() -> void:
	options.show()


func _on_end_options_pressed() -> void:
	options.show()


func _on_read_write_data_loaded(data: UserData) -> void:
	set_records(data.chain_records, data.individual_records)


func _on_read_write_data_saved(data: UserData) -> void:
	set_records(data.chain_records, data.individual_records)


func _on_score_finalized(chain_count: int, individual_count: int) -> void:
	end.set_score(chain_count, individual_count)
	end.show()
