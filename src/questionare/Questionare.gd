
class_name Questionare extends Object

signal ended()

var _is_ended: bool
var _question_index: int
var _question_list: Array[QuestionType]

func _init(question_list_resource: QuestionList) -> void:
	var question_list = question_list_resource.questions
	var question_list_size = question_list.questions.size()
	
	if question_list_size == 0:
		push_error("Given an empty question list")
		return
	
	_question_list = question_list.map(func(q: QuestionType): return Question.new(q))


func next() -> Question:
	var question_list_size = _question_list.size()
	
	if _question_index > question_list_size:
		push_error("Questionare list is exhausted")
		return
		
	var question = _question_list[_question_index]
	
	_question_index += 1
	if _question_index == question_list_size:
		_is_ended = true
		ended.emit()
	
	return question


func is_ended() -> bool:
	return _is_ended


func all() -> Array[Question]:
	return Array(_question_list)
