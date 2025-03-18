
class_name RoundScreen extends ClientScreen

var _round: Round
var _arena: RoundArena

@export var _arena_holder: Node2D


func on_enter(ctx: GameContext) -> void:
	if !ctx.has_round_info():
		push_error("Entered round screen, but round info was not set")
		return
	_init_round_from(ctx.get_current_round_info())
	_inject_round_arena(_arena)


func _init_round_from(round_info: RoundInfo) -> void:
	_round = Round.new(round_info)
	
	if !_round.is_arena_available():
		push_error("Round arena is not set")
		return
	
	_arena = _round.get_arena()


func _inject_round_arena(arena: RoundArena) -> void:
	_arena_holder.add_child(arena)
