## Represents a sequence of questions, that can be iterated
## using the [member next] method.
class_name Questionare extends Object


#region signals

signal ended()

#endregion


#region fields

var _is_ended: bool
var _question_index: int = 0
var _question_list: Array[Question]

#endregion


#region constructor

func _init(question_list: QuestionList, participants: Array[PlayerInfo]) -> void:
	var question_types = question_list.questions
	
	if question_types.size() == 0:
		push_error("Given an empty question list")
		return
	
	var questions = question_types.map(func(q: QuestionType): return Question.new(q, participants))
	_question_list.assign(questions)

#endregion


#region public

## Get the next question from sequence.
## If question sequence was exhausted and method was called,
## return error. Use the [member is_ended] method to check,
## that sequence is not empty.
## Also when the last question was popped, signal [signal ended] will
## be fired.
func next() -> Question:
	var question_list_size = _question_list.size()
	
	if _question_index >= question_list_size:
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

#endregion
