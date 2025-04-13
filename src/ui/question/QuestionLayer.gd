class_name QuestionLayer extends Control

@onready var _question_shadow: ColorRect = %"QuestionShadow"
@onready var _question_layout: QuestionLayout = %"QuestionLayout"


func set_layer_visible(value: bool) -> void:
	_question_shadow.visible = value
	_question_layout.visible = value


func get_question_layout() -> QuestionLayout:
	return _question_layout
