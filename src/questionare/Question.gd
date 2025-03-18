
class_name Question extends Object

signal answered(answer: Answer)

var _type: QuestionType
var _answer: Answer

func _init(type: QuestionType) -> void:
	_type = type


func _is_variant_correct(value: String) -> bool:
	var variants = _type.variants
	if variants.size() == 0:
		push_error("Variants are missing on question type " + _type.to_string())
		return false
	return value == variants[_type.correct_index]


func get_type() -> QuestionType:
	return _type


func get_answer() -> Answer:
	return _answer


func answer(value: String, who) -> void:
	_answer = Answer.new(
		value,
		who,
		_is_variant_correct(value))
	answered.emit(_answer)


class Answer:
	
	var _value: String
	var _who_answered: PlayerInfo
	var _correct: bool
	
	func _init(
			value: String,
			player: PlayerInfo,
			correct: bool) -> void:
		_value = value
		_who_answered = player
		_correct = correct
	
	func get_value() -> String:
		return _value
	
	func get_who_answered():
		return _who_answered
	
	func is_correct() -> bool:
		return _correct
