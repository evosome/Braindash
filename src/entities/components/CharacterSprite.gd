class_name CharacterSprite extends Node2D

## Fired when attack is gonna be performed while playing animation
signal attack_happened

enum Animations {
	IDLE,
	ATTACK,
	HURT
}

enum LookDirections {
	LEFT,
	RIGHT
}

@export var _sprite: AnimatedSprite2D
@export var _animation_player: AnimationPlayer


#region public

func look_at_direction(direction: LookDirections) -> void:
	_sprite.flip_h = direction == LookDirections.LEFT


func play_animation(animation: Animations) -> void:
	var animation_name = Animations.find_key(animation)
	if !_animation_player.has_animation(animation_name):
		push_error(
			"Animation: ",
			animation_name,
			" is not set on sprite.")
		return
	_animation_player.play(animation_name)


func async_play_animation(animation: Animations) -> void:
	play_animation(animation)
	await _animation_player.animation_finished

#endregion


#region protected

##TODO: Use states on player character, instead of using this
## Shorthand for emitting attack event. Call this method only in animations.
func perform_attack() -> void:
	attack_happened.emit()

#endregion
