class_name QuestionResult extends Object

var _is_draw: bool
var _winner: PlayerInfo
var _losers: Array[PlayerInfo]
var _answers: Array[Question.Answer]


#region built-in

func _init(answers: Array[Question.Answer]) -> void:
	_answers = answers
	_winner = _determine_winner(answers)
	_is_draw = _winner == null
	
	_losers.assign(answers
			.map(func(a: Question.Answer): return a.get_who_answered())
			.filter(func(p: PlayerInfo): return p != _winner))

#endregion


#region public

func is_draw() -> bool:
	return _is_draw


func get_winner() -> PlayerInfo:
	return _winner


func get_losers() -> Array[PlayerInfo]:
	return _losers as Array[PlayerInfo]

#endregion


#region private

func _determine_winner(answers: Array[Question.Answer]) -> PlayerInfo:
	var first_correct_answer = (answers
			.filter(func (a: Question.Answer): return a.is_correct())
			.pop_front())
	if !first_correct_answer:
		return null
	return first_correct_answer.get_who_answered()

#endregion
