class_name IntroScreen extends ClientScreen


#region fields

@export var _animation_player: AnimationPlayer

#endregion


#region virtual

func on_enter(_ctx: SharedContext) -> void:
	_animation_player.play("intro_animation")
	await _animation_player.animation_finished

	switch("menu")

#endregion
