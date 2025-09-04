class_name IntroScreen extends ClientScreen

@export var _animation_player: AnimationPlayer


#region virtual

func on_enter(ctx: GameContext) -> void:
	_animation_player.play("intro_animation")
	await _animation_player.animation_finished

	# TODO - make indexing and loading user data async and await it here...
	ctx.user_data = UserData.new()

	ctx.switch_screen("menu")

#endregion
