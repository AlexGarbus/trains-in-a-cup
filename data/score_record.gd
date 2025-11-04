class_name ScoreRecord
extends Object


var value: int
var name: String


func _init(initial_value := 0, initial_name := "") -> void:
	value = initial_value
	name = initial_name


func to_dictionary() -> Dictionary:
	return {
		"value" : value,
		"name" : name
	}


func from_dictionary(dict: Dictionary) -> void:
	value = dict.value
	name = dict.name
