extends HBoxContainer


@onready var _chain_list := %ChainList
@onready var _individual_list := %IndividualList


func set_records(chain: Array[ScoreRecord], individual: Array[ScoreRecord]) -> void:
	_chain_list.set_records(chain)
	_individual_list.set_records(individual)
