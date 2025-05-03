class_name CharacterSprite extends AnimatedSprite2D

enum Animations {
	IDLE,
	ATTACK,
	GOT_DAMAGE,
	DIED,
	VICTORY
}

var _animation_names = [
	"idle",
	"attack",
	"got_damage",
	"died",
	"victory"
]

func play_animation(animation: Animations) -> void:
	var animation_name = _animation_names[animation as int]
	play(animation_name)
