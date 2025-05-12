extends CanvasLayer


@onready var title := $Title
@onready var end := $End
@onready var spawner := $"../Spawner"


func _on_main_play_state_entered() -> void:
	title.hide()
	end.hide()


func _on_main_end_state_entered() -> void:
	end.show()
	end.set_score(spawner.chains_spawned, get_tree().get_node_count_in_group("trains"))
	# FIXME
	# Need more accurate score tracking.
	# Consider removing the count variables from spawner.gd
	# or the destroy_all() function from train.gd if not needed.
