class_name UserData
extends Object


const RECORD_COUNT := 5


var chain_records: Array[ScoreRecord]
var individual_records: Array[ScoreRecord]


func initialize_all_records() -> void:
	initialize_records(chain_records)
	initialize_records(individual_records)


func initialize_records(array: Array[ScoreRecord]) -> void:
	array.resize(RECORD_COUNT)
	for i in range(RECORD_COUNT):
		array[i] = ScoreRecord.new()


## Returns the index of the inserted score, or -1 if insertion fails.
func insert_chain_score(score: int) -> int:
	return _insert_score(score, chain_records)


## Returns the index of the inserted score, or -1 if insertion fails.
func insert_individual_score(score: int) -> int:
	return _insert_score(score, individual_records)


## Returns the index of the inserted score, or -1 if insertion fails.
func _insert_score(score: int, array: Array[ScoreRecord]) -> int:
	for i in range(array.size()):
		if score > array[i].value:
			for j in range(array.size() - 1, i, -1):
				array[j].value = array[j - 1].value
				array[j].name = array[j - 1].name
			array[i].value = score
			array[i].name = ""
			return i
	return -1

#region Dictionary Conversion
func to_dictionary() -> Dictionary[String, Array]:
	return {
		"chain_records" : _records_to_dictionaries(chain_records),
		"individual_records" : _records_to_dictionaries(individual_records)
	}


func from_dictionary(dict: Dictionary[String, Array]) -> void:
	chain_records = _records_from_dictionaries(dict.chain_records)
	individual_records = _records_from_dictionaries(dict.individual_records)


func _records_to_dictionaries(records: Array[ScoreRecord]) -> Array[Dictionary]:
	var array: Array[Dictionary]
	for record in records:
		array.append(record.to_dictionary())
	return array


func _records_from_dictionaries(dicts: Array[Dictionary]) -> Array[ScoreRecord]:
	var array: Array[ScoreRecord]
	for i in range(dicts.size()):
		array.append(ScoreRecord.new(dicts[i].value, dicts[i].name))
	return array
#endregion
