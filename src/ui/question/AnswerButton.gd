class_name AnswerButton extends Button

var _answer_containing: String


#region public

func set_answer_text(value: String) -> void:
	_answer_containing = value
	_set_button_text(value)


func get_answer_text() -> String:
	return _answer_containing

#endregion


#region private

func _set_button_text(value: String) -> void:
	text = value

#endregion
