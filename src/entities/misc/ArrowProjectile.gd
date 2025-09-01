class_name ArrowProjectile extends Node2D


#region constants

const PRELOADED_SCENE = preload("ArrowProjectile.tscn")

#endregion


#region fields

var _initial_position: Vector2
var _target_position: Vector2
var _fly_speed: float
var _is_destroy_on_end: bool
var _fly_tween: Tween

#endregion


#region getter/setter

func set_initial_position(value: Vector2) -> void:
	_initial_position = value


func get_initial_position() -> Vector2:
	return _initial_position


func set_target_position(value: Vector2) -> void:
	_target_position = value


func get_target_position() -> Vector2:
	return _target_position


func set_fly_speed(value: float) -> void:
	_fly_speed = value


func get_fly_speed() -> float:
	return _fly_speed


func set_destroy_on_end(value: bool) -> void:
	_is_destroy_on_end = value


func is_destroy_on_end() -> bool:
	return _is_destroy_on_end

#endregion


#region public

## This method is asynchronous.
func fly() -> void:

	if _fly_tween:
		_fly_tween.kill()
	
	position = _initial_position
	look_at(_target_position)

	_fly_tween = create_tween()
	_fly_tween.tween_property(self, "position", _target_position, _fly_speed)

	await _fly_tween.finished

	if _is_destroy_on_end:
		queue_free()

#endregion


#region static

static func make(from_pos: Vector2, to_pos: Vector2, speed: float, destroy_on_end: bool = true) -> ArrowProjectile:
	var instantiated_arrow = PRELOADED_SCENE.instantiate()
	instantiated_arrow.set_initial_position(from_pos)
	instantiated_arrow.set_target_position(to_pos)
	instantiated_arrow.set_fly_speed(speed)
	instantiated_arrow.set_destroy_on_end(destroy_on_end)
	return instantiated_arrow

#endregion
