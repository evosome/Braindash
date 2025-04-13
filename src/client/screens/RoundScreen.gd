
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
	round_.add_player(_player)

	_ai_enemy = ctx.get_enemy()
	round_.add_player(_ai_enemy)


func _listen_signals_from(round: Round) -> void:
	round.question_just_spawned.connect(_on_question_just_spawned)
	round.question_ended.connect(_on_question_ended)

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

#endregion
