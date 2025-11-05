@tool
extends Label


const EDITOR_LINES := 5
const EDITOR_SCORE := 100
const EDITOR_NAME := "NAME"

## The text that will be printed on each line.
## "%s" will be replaced by the line number, score, and name, in that order.
@export var line_text = "%s) %s - %s"
@export_tool_button("Update Text") var set_editor_text_action := _set_editor_text


func set_records(score_records: Array[ScoreRecord]) -> void:
	text = ""
	for i in range(score_records.size()):
		if i > 0:
			text += "\n"
		text += (line_text % [i + 1, score_records[i].value, score_records[i].name])


func _set_editor_text() -> void:
	if not Engine.is_editor_hint():
		return
	var score_records: Array[ScoreRecord]
	for i in range(EDITOR_LINES):
		score_records.append(ScoreRecord.new(EDITOR_SCORE, EDITOR_NAME))
	set_records(score_records)
	for record in score_records:
		record.free()
