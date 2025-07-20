class_name CharacterSprite extends Node2D


#region shader constants

const SHADER_PRELOADED = preload("CharacterSprite.gdshader")
const WIDTH_PARAM = "width"
const DEFAULT_WIDTH = 8.0

#endregion

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

var _is_glowing: bool = false
var _shader_material: ShaderMaterial

@export var _sprite: AnimatedSprite2D
@export var _animation_player: AnimationPlayer


#region builtin

func _ready() -> void:
	var sprite_material = ShaderMaterial.new()
	sprite_material.set_shader(SHADER_PRELOADED)
	_sprite.set_material(sprite_material)
	_shader_material = sprite_material

	set_glowing(false)

#endregion


#region getter/setter

func set_glowing(value: bool) -> void:
	_is_glowing = value
	_shader_material.set_shader_parameter(WIDTH_PARAM, DEFAULT_WIDTH if value else 0.0)


func get_glowing() -> bool:
	return _is_glowing


func get_rect() -> Rect2:
	var current_animation = _sprite.animation
	var current_frame_count = _sprite.frame
	var current_frame = _sprite.sprite_frames.get_frame_texture(current_animation, current_frame_count)
	return Rect2(_sprite.position, current_frame.get_size())

#endregion


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
