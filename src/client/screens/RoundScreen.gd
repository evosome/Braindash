
class_name RoundScreen extends ClientScreen

var _round: Round
var _arena: RoundArena
var _current_question_type: QuestionType

var _player: PlayerInfo
var _ai_enemy: PlayerInfo

@export var _arena_holder: Node2D

@onready var _question_layer: QuestionLayer = %"QuestionLayer"
@onready var _question_layout: QuestionLayout = _question_layer.get_question_layout()


#region built-in

func _ready() -> void:
	_question_layer.set_layer_visible(false)

#endregion


#region virtual

func on_enter(ctx: GameContext) -> void:
	if !ctx.has_round_info():
		push_error("Entered round screen, but round info was not set")
		return

	var round_info = ctx.get_current_round_info()

	_round = _init_round_from(round_info)
	_inject_round(_round)
	_arena = _round.get_arena()
	
	_listen_signals_from(_round)
	_add_players_from(ctx, _round)
	
	_question_layout.answered.connect(_on_question_layout_got_answer)

	_round.start()

#endregion


#region private

func _init_round_from(round_info: RoundInfo) -> Round:
	return Round.new(round_info)


func _inject_round(round_: Round) -> void:
	_arena_holder.add_child(round_)


func _add_players_from(ctx: GameContext, round_: Round) -> void:
	_player = ctx.get_me()
	var player_character_type = ctx.get_my_character_type()
	round_.add_player(_player)
	round_.create_character_for(_player, player_character_type)

	_ai_enemy = ctx.get_enemy()
	var enemy_character_type = ctx.get_enemy_character_type()
	round_.add_player(_ai_enemy)
	round_.create_character_for(_ai_enemy, enemy_character_type)
	
	#TODO: implement team system, instead of setting targets like this
	var player_char = round_.get_character_of(_player)
	var enemy_char = round_.get_character_of(_ai_enemy)
	player_char.set_target(enemy_char)
	enemy_char.set_target(player_char)
	player_char.look_at_other(enemy_char)
	enemy_char.look_at_other(player_char)


func _listen_signals_from(round: Round) -> void:
	round.question_just_spawned.connect(_on_question_just_spawned)
	round.question_ended.connect(_on_question_ended)


func _perform_smashing(winner: PlayerInfo, losers: Array[PlayerInfo]) -> void:
	var winner_char = _round.get_character_of(winner)
	
	var loser_chars: Array[PlayerCharacter]
	loser_chars.assign(
		losers
			.map(func(l: PlayerInfo): return _round.get_character_of(l)))
	
	var smash_info = SmashInfo.new()
	smash_info.set_damage(25)
	smash_info.set_winner_character(winner_char)
	smash_info.set_loser_characters(loser_chars)
	await _arena.async_smash(smash_info)

#endregion


#region event handlers

func _on_question_just_spawned(question_type: QuestionType) -> void:
	_current_question_type = question_type
	_question_layer.set_layer_visible(true)
	_question_layout.set_disabled(false)
	_question_layout.set_question_type(question_type)
	_question_layout.start_question_timer()


func _on_question_layout_got_answer(variant: String) -> void:
	_question_layout.set_disabled(true)
	_question_layer.set_layer_visible(false)
	_round.answer_on_current(variant, _player)
	
	#FIXME: temporary added logic for AI player there. Its gonna be moved
	# to other class probably
	_round.answer_on_current(
		_current_question_type.variants[_current_question_type.correct_index],
		_ai_enemy)


func _on_question_ended(result: QuestionResult) -> void:
	_question_layer.set_layer_visible(false)
	_question_layout.reset_question_timer()
	
	if !result.is_draw():
		var winner = result.get_winner()
		var losers = result.get_losers()
		await _perform_smashing(winner, losers)
	else:
		await _arena.async_on_draw()
	
	_round.do_continue()

#endregion
