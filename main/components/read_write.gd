extends Node


const USER_DATA_PATH := "user://save.dat"

signal data_loaded(data: UserData)
signal data_saved(data: UserData)
signal data_updated(awaiting_name: bool)

var current_data: UserData
var _chain_awaiting_name := -1
var _individual_awaiting_name := -1


func _ready() -> void:
	current_data = UserData.new()
	if FileAccess.file_exists(USER_DATA_PATH):
		read_data()
	else:
		current_data.initialize_all_records()
		write_data()


func read_data() -> void:
	var file := FileAccess.open(USER_DATA_PATH, FileAccess.READ)
	var error := FileAccess.get_open_error()
	if error != OK:
		push_error(str("Error opening file: ", error))
		return
	var dict := file.get_var() as Dictionary[String, Array]
	if dict:
		current_data.from_dictionary(dict)
	else:
		push_error("File read failed.")
		return
	file.close()
	data_loaded.emit(current_data)


func write_data() -> void:
	var file := FileAccess.open(USER_DATA_PATH, FileAccess.WRITE)
	var error := FileAccess.get_open_error()
	if error != OK:
		push_error(str("Error opening file: ", error))
		return
	file.store_var(current_data.to_dictionary())
	file.close()
	data_saved.emit(current_data)


func _is_awaiting_name() -> bool:
	return _chain_awaiting_name > -1 || _individual_awaiting_name > -1


func _on_score_finalized(chain_count: int, individual_count: int) -> void:
	_chain_awaiting_name = current_data.insert_chain_score(chain_count)
	_individual_awaiting_name = current_data.insert_individual_score(individual_count)
	data_updated.emit(_is_awaiting_name())


func _on_end_name_submitted(record_name: String) -> void:
	if _chain_awaiting_name > -1:
		current_data.chain_records[_chain_awaiting_name].name = record_name
		_chain_awaiting_name = -1
	if _individual_awaiting_name > -1:
		current_data.individual_records[_individual_awaiting_name].name = record_name
		_individual_awaiting_name = -1
	data_updated.emit(false)
	write_data()
