class_name Round extends Object

## Fired, when the round is over (because it's questionare list is empty)
signal ended()

## Fired, when a new question was taken from questionare and players are about to answer for this
signal question_just_spawned(question_type: QuestionType)

## Fired, when any player answered for question
signal someone_answered(player: PlayerInfo, answer: Question.Answer)

## Fired, when all players answered for questions and winner is known
signal question_ended(winner: PlayerInfo)

const MAX_PLAYERS_COUNT = 2

var _info: RoundInfo
var _external_timer: Timer
var _arena: RoundArena
var _questionare: Questionare
var _is_ended: bool = false
var _is_running: bool = false
var _current_question: Question

var _players: Array[PlayerInfo] = []


func _init(round_info: RoundInfo) -> void:
	_info = round_info
	_questionare = Questionare.new(round_info.question_list)
	_arena = _instantiate_arena_from(round_info)
	_external_timer = _arena.get_timer()


func _instantiate_arena_from(round_info: RoundInfo) -> RoundArena:
	var packed_arena = round_info.packed_arena
	if !packed_arena:
		push_error("Round arena is not set in round info: " + _info.to_string())
		return
	return packed_arena.instantiate()


func _async_process_gameplay() -> void:
	while !_questionare.is_ended():
		_current_question = _questionare.next()
		_current_question.answered.connect(_on_question_answered)

		question_just_spawned.emit(_current_question.get_type())
		print_debug("Question spawned: " + _current_question.to_string())

		while !_has_answers_from_all_players(_current_question.get_answers()):
			await _current_question.answered
		
		_current_question.answered.disconnect(_on_question_answered)
		print_debug("All players answered for the question. Wave is over...")

		#TODO: Async wait for attacking animation on arena might go there
		# like: await _arena.smash_happened
	
	ended.emit()
	print_debug("Round is over...")


func _has_answers_from_all_players(answers: Array[Question.Answer]) -> bool:
	if answers.is_empty():
		return false

	return answers.all(
		func(a: Question.Answer):
			return _players.has(a.get_who_answered()))


func _on_question_answered(answer: Question.Answer) -> void:
	var player_answered = answer.get_who_answered()
	someone_answered.emit(player_answered, answer)
	print_debug(
		"Player" + player_answered.to_string() + " answered for question " + answer.to_string())


func is_arena_available() -> bool:
	return _arena != null


func get_info() -> RoundInfo:
	return _info


func get_arena() -> RoundArena:
	return _arena


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
	if !_arena.is_node_ready():
		print("Round arena must be in node tree (arena is not ready)")
		return

	var players_count = _players.size()
	if players_count != MAX_PLAYERS_COUNT:
		push_error("Unable to start round as there's not enough players")
		return

	await _async_process_gameplay()
