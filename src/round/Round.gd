class_name Round


#region enums

## Represents variants of round end. Round can be ended, when time is over or
## all players answered for a question.
enum EndReason {
	ALL_ANSWERED,
	TIMEOUT

#endregion


#region signals

## Fired, when the round is over and result of it was determined.
signal ended(result: Result)}

# Internal signal, used to await, when any of two conditions are happend:
# - timer is timed out
# - all players are answered for the current question.
#TODO: I maybe will rewrite it with using some signal helper libraries
signal _internal_ended

#endregion


#region fields

var _timer: Timer
var _question: Question
var _end_reason: EndReason
var _is_over: bool = false
var _result: Result

#endregion


#region constructor

func _init(question: Question, timer: Timer) -> void:
	_timer = timer
	_question = question

#endregion


#region getters/setters

## Get last result of round if round is over. Helpful when not awaiting async method
## `start`.
func get_result() -> Result:
	if !_is_over:
		push_warning("Trying to access round result, but has not ended yet")
		return null
	return _result

#endregion


#region public

func is_over() -> bool:
	return _is_over


## This method is asynchronous. Start the round and wait until any of two reasons happenned:
## time is over or all players answered for a question.
func start() -> Result:
	var question_type = _question.get_type()
	if question_type.has_timeout():
		_timer.start(question_type.timeout_seconds)
		_timer.timeout.connect(_on_timeout)
	
	_question.all_participants_answered.connect(_on_all_answered)

	await _internal_ended

	_timer.timeout.disconnect(_on_timeout)
	_question.all_participants_answered.disconnect(_on_all_answered)

	_result = Result.new(_question, _end_reason)
	_is_over = true
	ended.emit(_result)
	return _result


## Get the question associated with this round
func get_question() -> Question:
	return _question

#endregion


#region event handlers

func _on_timeout() -> void:
	_end_reason = EndReason.TIMEOUT
	_internal_ended.emit()


func _on_all_answered() -> void:
	_end_reason = EndReason.ALL_ANSWERED
	_internal_ended.emit()

#endregion


#region inner classes

class Result:

	var _answers: Array[Question.Answer]
	var _end_reason: EndReason
	var _best_answer: Question.Answer

	func _init(question: Question, end_reason: EndReason) -> void:
		_answers = question.get_answers()
		_end_reason = end_reason
		_best_answer = _determine_best()
		_answers.erase(_best_answer)
	
	func is_draw() -> bool:
		return _best_answer == null
	
	func get_end_reason() -> EndReason:
		return _end_reason
	
	func get_best_answer() -> Question.Answer:
		return _best_answer
	
	func get_worse_answers() -> Array[Question.Answer]:
		return _answers
	
	func _determine_best() -> Question.Answer:
		# ascending sort by answer timestamps
		_answers.sort_custom(
			func(x: Question.Answer, y: Question.Answer):
				return x.get_timestamp() < y.get_timestamp())

		# find first correct answer in sorted array
		var index = _answers.find_custom(func(a: Question.Answer): return a.is_correct())
		return _answers[index] if index != -1 else null

#endregion
