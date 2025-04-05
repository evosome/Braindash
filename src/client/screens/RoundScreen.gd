
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
	_arena = _init_round_arena(_round)
	_inject_round_arena(_arena)

	_round.add_player(_player)
	_round.add_player(_ai_enemy)

	_round.question_just_spawned.connect(
		func (question_type: QuestionType):
			_question_layout.set_question_title(question_type.title)
			_question_layout.set_question_image_texture(question_type.image)
	)

	_round.start()


func _init_round_from(round_info: RoundInfo) -> Round:
	return Round.new(round_info)


func _init_round_arena(round_: Round) -> RoundArena:
	return round_.get_arena()


func _inject_round_arena(arena: RoundArena) -> void:
	_arena_holder.add_child(arena)
