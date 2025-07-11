class_name SingleplayerGameScreen extends ClientScreen

@onready var _game_container: Node = %"GameContainer"
@onready var _question_layer: QuestionLayer = %"QuestionLayer"
@onready var _round_popup: RoundPopup = %"RoundPopup"


#region built in

func _ready() -> void:
	assert(_game_container != null, "Game container node do not exists on RoundScreen scene")
	assert(_question_layer != null, "Question layer node do not exists on RoundScreen scene")

	_question_layer.set_layer_visible(false)

#endregion


#region virtual

func on_enter(ctx: GameContext) -> void:

	if !ctx.has_round_info():
		push_error("Entered game screen, but round info was not set")
		return

	# resolve game info
	var game_info = ctx.get_current_round_info()

	# get players from context
	var me = ctx.get_me()
	var enemy = ctx.get_enemy()

	# init game instance
	var singleplayer_game = SingleplayerGame.make(game_info, me, enemy)
	_game_container.add_child(singleplayer_game)

	# spawn characters for players
	singleplayer_game.spawn_character_for(me, ctx.get_my_character_type())
	singleplayer_game.spawn_character_for(enemy, ctx.get_enemy_character_type())

	# init state machine, create state context and register states
	var state_manager = StateManager.new()

	var game_context = GameStateContext.new()
	game_context.game = singleplayer_game
	game_context.state_manager = state_manager
	game_context.question_layer = _question_layer
	game_context.round_popup = _round_popup
	state_manager.set_context(game_context)

	state_manager.register("intro", IntroState.new())
	state_manager.register("introduce_question", IntroduceQuestionState.new())
	state_manager.register("answer", AnswerState.new())
	state_manager.register("wait_opponent", WaitOpponentState.new())
	state_manager.register("round_over", RoundOverState.new())
	state_manager.register("fight", FightState.new())
	state_manager.register("outro", OutroState.new())

	state_manager.transition_to("intro")

#endregion


#region states

class GameStateContext:

	# permanent fields
	var game: SingleplayerGame
	var state_manager: StateManager
	var question_layer: QuestionLayer
	var current_round: Round
	var round_popup: RoundPopup

	# shared fields between states
	var round_result: Round.Result

	## Shorthand for [code]ctx.state_manager.transition_to(...)[/code]
	func transition_to(state_name: String) -> void:
		state_manager.transition_to(state_name)


class GameState:
	extends State

	@warning_ignore("unused_parameter")
	func on_enter(ctx: GameStateContext) -> void:
		pass
	
	@warning_ignore("unused_parameter")
	func on_exit(ctx: GameStateContext) -> void:
		pass


class IntroState:
	extends GameState

	func on_enter(ctx: GameStateContext) -> void:
		print_debug("Entered intro state")

		ctx.transition_to("introduce_question")


class IntroduceQuestionState:
	extends GameState

	func on_enter(ctx: GameStateContext) -> void:
		print_debug("Entered introduce question state")

		var game = ctx.game
		var current_round = game.get_next_round()
		ctx.current_round = current_round

		var current_question = current_round.get_question()

		var question_layer = ctx.question_layer
		question_layer.set_layer_visible(true)

		var question_layout = question_layer.get_question_layout()
		question_layout.set_question_type(current_question.get_type())
		question_layout.set_disabled(false)

		ctx.transition_to("answer")


class AnswerState:
	extends GameState

	enum EndReason {
		ANSWERED,
		TIMEOUT
	}

	var _answer_text: String

	signal _internal_ended(reason: EndReason)

	func on_enter(ctx: GameStateContext) -> void:
		print_debug("Entered answer state")

		var current_round = ctx.current_round
		current_round.start()

		# start countdown timer
		var question_layer = ctx.question_layer
		var question_layout = question_layer.get_question_layout()
		question_layout.start_question_timer()

		question_layout.answered.connect(_on_answered)
		current_round.ended.connect(_on_timeout)

		var end_reason = await _internal_ended

		question_layout.answered.disconnect(_on_answered)
		current_round.ended.disconnect(_on_timeout)

		match end_reason:
			EndReason.ANSWERED:
				var game = ctx.game
				var local_player = game.get_local_player()
				var current_question = current_round.get_question()
				current_question.answer(_answer_text, local_player)
				ctx.transition_to("wait_opponent")

				#FIXME - temporary ai logic here, remove it
				var question_type = current_question.get_type()
				var correct_answer = question_type.get_correct()
				current_question.answer(correct_answer, game.get_enemy_player())

			EndReason.TIMEOUT:
				ctx.round_result = current_round.get_result()
				ctx.transition_to("round_over")
	
	func _on_answered(text: String) -> void:
		_answer_text = text
		_internal_ended.emit(EndReason.ANSWERED)
	
	func _on_timeout(_result) -> void:
		_internal_ended.emit(EndReason.TIMEOUT)


class WaitOpponentState:
	extends GameState

	func on_enter(ctx: GameStateContext) -> void:
		print_debug("Entered wait opponent state")

		var current_round = ctx.current_round
		if !current_round.is_over():
			await current_round.ended
		ctx.round_result = current_round.get_result()

		ctx.transition_to("round_over")


class RoundOverState:
	extends GameState

	func on_enter(ctx: GameStateContext) -> void:
		print_debug("Entered round over state")

		var question_layer = ctx.question_layer
		question_layer.set_layer_visible(false)

		var game = ctx.game
		var local_player = game.get_local_player()

		var round_result = ctx.round_result

		var round_popup = ctx.round_popup
		var popup_badge = RoundPopup.PopupBadge.WRONG
		if round_result.is_draw():
			popup_badge = RoundPopup.PopupBadge.DRAW
		else:
			var best_result = round_result.get_best_answer()

			if best_result.get_who_answered() == local_player:
				popup_badge = RoundPopup.PopupBadge.CORRECT

		await round_popup.show_popup(popup_badge)

		ctx.transition_to("fight")


class FightState:
	extends GameState

	func on_enter(ctx: GameStateContext) -> void:
		print_debug("Entered fight state")

		var game = ctx.game
		var round_result = ctx.round_result
		
		await game.do_fight(round_result)
		
		var next_state = "introduce_question" if !game.is_over() else "outro"
		ctx.transition_to(next_state)


class HealthCountdownState:
	extends GameState

	func on_enter(ctx: GameStateContext) -> void:
		pass


class OutroState:
	extends GameState

	func on_enter(ctx: GameStateContext) -> void:
		print_debug("Entered outro state")

#endregion
