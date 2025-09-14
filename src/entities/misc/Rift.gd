class_name Rift extends Node2D

const PRELOADED_SCENE = preload("Rift.tscn")

var _lifetime: float = 1.0
var _destroy_on_end: bool

@export var _animated_sprite: AnimatedSprite2D
@export var _animation_player: AnimationPlayer


#region getter/setter

func set_destroy_on_end(value: bool) -> void:
	_destroy_on_end = value


func is_destroy_on_end() -> bool:
	return _destroy_on_end


func set_hflip(value: bool) -> void:
	_animated_sprite.flip_h = value


func get_hflip() -> bool:
	return _animated_sprite.flip_h


#endregion


#region public

## This method is asynchronous. Make the rift come from the ground with growing animation.
func come_from_ground() -> void:
	_animation_player.play("grow")
	await _animation_player.animation_finished

	_do_fade(_destroy_on_end)

#endregion


#region private

func _do_fade(need_destroy: bool) -> void:

	await get_tree().create_timer(_lifetime).timeout

	_animation_player.play("fade")
	await _animation_player.animation_finished

	if need_destroy:
		queue_free()

#endregion


#region static

static func make() -> Rift:
	var rift_instantiated = PRELOADED_SCENE.instantiate()
	return rift_instantiated

#endregion
