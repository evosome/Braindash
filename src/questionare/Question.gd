
class_name Question


#region signals

## Fired when certain player answered for the question.
signal answered(participant: PlayerInfo, answer: Answer)

## Fired when all players answered for the question.
signal all_participants_answered()

#endregion


#region fields

var _type: QuestionType
var _participants: Array[PlayerInfo]
var _answers_map: Dictionary[PlayerInfo, Answer]

#endregion


#region constructor

func _init(type: QuestionType, players: Array[PlayerInfo]) -> void:
	_type = type
	_participants = players

#endregion


#region public

## Add string-like answer associated with participant (player).
## Player can answer once. So if player is trying to answer again, error appears.
func answer(value: String, participant: PlayerInfo) -> void:
	if _answers_map.has(participant):
		push_error("Player has already answered! Player: " + participant.to_string())
		return

	var new_answer = Answer.new(
		value,
		participant,
		_is_variant_correct(value))

	_answers_map[participant] = new_answer
	answered.emit(participant, new_answer)

	if _all_players_answered():
		all_participants_answered.emit()


func get_type() -> QuestionType:
	return _type


func get_answers() -> Array[Answer]:
	return _answers_map.values()


func get_answer_of(participant: PlayerInfo) -> Answer:
	return _answers_map.get(participant)

#endregion


#region private

func _is_variant_correct(value: String) -> bool:
	var variants = _type.variants
	if variants.size() == 0:
		push_error("Variants are missing on question type " + _type.to_string())
		return false
	return value == variants[_type.correct_index]


func _all_players_answered() -> bool:
	var is_all_answered = _participants.all(func(p: PlayerInfo): return _answers_map.has(p))
	return is_all_answered

#endregion


#region inner classes

## Represents each answer of a participant of the question
class Answer:
	
	var _value: String
	var _who_answered: PlayerInfo
	var _correct: bool
	var _timestamp: float
	
	func _init(
			value: String,
			player: PlayerInfo,
			correct: bool) -> void:
		_value = value
		_who_answered = player
		_correct = correct
		_timestamp = Time.get_unix_time_from_system()
	
	func _to_string() -> String:
		return "Answer(value=\"{value}\", who_answered=\"{who_answered}\", is_correct={is_correct})".format({
			value = _value,
			who_answered = _who_answered,
			is_correct = _correct
		})
	
	func get_value() -> String:
		return _value
	
	func get_who_answered() -> PlayerInfo:
		return _who_answered
	
	func is_correct() -> bool:
		return _correct
	
	## Get unix timestamp (float) when the answer was created,
	## describing when a player exactly answered for the question.
	func get_timestamp() -> float:
		return _timestamp

#endregion
