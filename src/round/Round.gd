class_name Round extends Node

## Fired, when the round is over (because it's questionare list is empty)
signal ended()

## Fired, when a new question was taken from questionare and players are about to answer for this
signal question_just_spawned(question_type: QuestionType)

## Fired, when any player answered for question
signal someone_answered(player: PlayerInfo, answer: Question.Answer)

## Fired, when all players answered for questions and winner is known
signal question_ended(result: QuestionResult)

const MAX_PLAYERS_COUNT = 2

var _info: RoundInfo
var _arena: RoundArena
var _timer: Timer = Timer.new()
var _players: Array[PlayerInfo] = []
var _questionare: Questionare
var _is_running: bool = false
var _current_question: Question


func _init(round_info: RoundInfo) -> void:
	_info = round_info
	_questionare = Questionare.new(round_info.question_list)
	_arena = _instantiate_arena_from(round_info)


func _ready() -> void:
	add_child(_arena)
	add_child(_timer)

	_timer.timeout.connect(_on_timer_timeout)


#region public


func get_info() -> RoundInfo:
	return _info


func get_arena() -> RoundArena:
	return _arena


func get_timer() -> Timer:
	return _timer


func add_player(player: PlayerInfo) -> void:
	var players_count = _players.size()
	if players_count == MAX_PLAYERS_COUNT:
		push_error("Only two players supported in game round")
		return

	_players.append(player)


func answer_on_current(variant: String, player: PlayerInfo) -> void:
	if !_players.has(player):
		push_error("The specified player is not on round")
		return
	
	_current_question.answer(variant, player)


func start() -> void:
	
	if _is_running:
		push_error("Round has already run")
		return

	var players_count = _players.size()
	if players_count != MAX_PLAYERS_COUNT:
		push_error("Unable to start round as there's not enough players (2 needed)")
		return
	
	_is_running = true

	await _async_process_gameplay()


#endregion


#region private


func _instantiate_arena_from(round_info: RoundInfo) -> RoundArena:
	var packed_arena = round_info.packed_arena
	if !packed_arena:
		push_error("Round arena is not set in round info: " + _info.to_string())
		return
	return packed_arena.instantiate()


func _async_process_gameplay() -> void:
	print_debug("Round is running...")

	while !_questionare.is_ended():
		_current_question = _questionare.next()
		_current_question.answered.connect(_on_question_answered)

		var question_type = _current_question.get_type()
		if question_type.has_timeout():
			_init_timer(question_type.timeout_seconds)
	
		question_just_spawned.emit(question_type)
		print_debug("Question spawned: " + _current_question.to_string())

		await question_ended
		
		print_debug("All players answered for the question. Wave is over...")

		_current_question.answered.disconnect(_on_question_answered)

		#TODO: Async wait for attacking animation on arena might go there
		# like: await _arena.smash_happened
	
	ended.emit()
	print_debug("Round is over...")


func _has_answers_from_all_players(answers: Array[Question.Answer]) -> bool:
	if answers.is_empty():
		return false

	var players_answered = answers.map(
		func(a: Question.Answer): return a.get_who_answered())
	
	var is_all_answered = _players.all(
		func(p: PlayerInfo): return players_answered.has(p))

	return is_all_answered


func _init_timer(timeout_seconds: float) -> void:
	_timer.start(timeout_seconds)


func _end_question_immediately(question: Question) -> void:
	var answers = question.get_answers()
	question_ended.emit(QuestionResult.new(answers))


#endregion


#region event handlers


func _on_question_answered(answer: Question.Answer) -> void:
	var player_answered = answer.get_who_answered()
	someone_answered.emit(player_answered, answer)
	print_debug(
		"Player " + player_answered.to_string() + " answered for question " + answer.to_string())
	
	if _has_answers_from_all_players(_current_question.get_answers()):
		_end_question_immediately(_current_question)


func _on_timer_timeout() -> void:
	_end_question_immediately(_current_question)


#endregion
