
class_name RoundScreen extends ClientScreen

var _round: Round
var _arena: RoundArena

var _player: PlayerInfo = PlayerInfo.new()
var _ai_enemy: PlayerInfo = PlayerInfo.new()

@export var _arena_holder: Node2D
@export var _question_layout: QuestionLayout


func on_enter(ctx: GameContext) -> void:
	if !ctx.has_round_info():
		push_error("Entered round screen, but round info was not set")
		return

	var round_info = ctx.get_current_round_info()

	_round = _init_round_from(round_info)
	_inject_round(_round)
	_listen_signals_from(_round)
	_add_players_from(ctx, _round)

	_round.start()


func _init_round_from(round_info: RoundInfo) -> Round:
	return Round.new(round_info)


func _inject_round(round_: Round) -> void:
	_arena_holder.add_child(round_)


func _add_players_from(ctx: GameContext, round_: Round) -> void:
	var current_player = ctx.get_me()
	round_.add_player(current_player)

	var current_enemy = ctx.get_enemy()
	round_.add_player(current_enemy)


func _listen_signals_from(round: Round) -> void:
	round.question_just_spawned.connect(_on_question_just_spawned)


func _on_question_just_spawned(question_type: QuestionType) -> void:
	_question_layout.set_question_title(question_type.title)
	_question_layout.set_question_timer_enabled(true)
	_question_layout.start_question_timer(question_type.timeout_seconds)
