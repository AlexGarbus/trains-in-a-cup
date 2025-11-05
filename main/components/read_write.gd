extends Node


const USER_DATA_PATH := "user://save.dat"
const LOG_PATH := "user://score_log.txt"
const LOG_ARGUMENT := "score-log"
const LOG_LINE := "%s - %s - %s"

signal data_loaded(data: UserData)
signal data_saved(data: UserData)
signal data_updated(awaiting_name: bool)

var current_data: UserData
var _chain_await_name_index := -1
var _individual_await_name_index := -1
var _log_enabled := false


func _ready() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.trim_prefix("--") == LOG_ARGUMENT:
			_log_enabled = true
			break
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


func write_log(record: ScoreRecord, suffix: String) -> void:
	var access_mode := FileAccess.READ_WRITE if FileAccess.file_exists(LOG_PATH) else FileAccess.WRITE
	var file := FileAccess.open(LOG_PATH, access_mode)
	var error := FileAccess.get_open_error()
	if error != OK:
		push_error(str("Error opening file: ", error))
		return
	file.seek_end()
	file.store_line(LOG_LINE % [record.name, record.value, suffix])
	file.close()


func _is_awaiting_name() -> bool:
	return _chain_await_name_index > -1 || _individual_await_name_index > -1


func _on_score_finalized(chain_count: int, individual_count: int) -> void:
	_chain_await_name_index = current_data.insert_chain_score(chain_count)
	_individual_await_name_index = current_data.insert_individual_score(individual_count)
	data_updated.emit(_is_awaiting_name())


func _on_end_name_submitted(record_name: String) -> void:
	if _chain_await_name_index > -1:
		var record := current_data.chain_records[_chain_await_name_index]
		record.name = record_name
		if _log_enabled:
			write_log(record, "chain")
	if _individual_await_name_index > -1:
		var record := current_data.individual_records[_individual_await_name_index]
		record.name = record_name
		if _log_enabled:
			write_log(record, "individual")
	_chain_await_name_index = -1
	_individual_await_name_index = -1
	data_updated.emit(false)
	write_data()
