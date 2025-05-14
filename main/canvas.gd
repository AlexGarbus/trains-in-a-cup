extends CanvasLayer


@onready var title := $Title
@onready var end := $End
@onready var score := %Score


func _on_main_play_state_entered() -> void:
	title.hide()
	end.hide()


func _on_main_end_state_entered() -> void:
	await get_tree().process_frame
	end.show()
	end.set_score(score.chain_count, score.individual_count)
