@tool
class_name DesintegrationBeam extends NinePatchSprite2D


#region constants

const COMMON_WIDTH = 128
const COMMON_FLASHING_SPEED = 0.2

const PRELOADED_SCENE = preload("DesintegrationBeam.tscn")

#endregion


#region fields

var _flash_tween: Tween
var _start_point: Vector2
var _end_point: Vector2
var _flasing_speed: float = COMMON_FLASHING_SPEED

#endregion


#region getter/setter

func set_start_point(value: Vector2) -> void:
	position = value
	_start_point = value


func set_end_point(value: Vector2) -> void:
	if _start_point.is_zero_approx():
		push_warning("Start position must be set first!")
		return
	
	var calculated_scale = _start_point.distance_to(value)
	size = Vector2(calculated_scale, COMMON_WIDTH)

	var calculated_rotation = _start_point.angle_to_point(value)
	rotation = calculated_rotation

	_end_point = value


func set_flashing_speed(value: float) -> void:
	_flasing_speed = value

#endregion


#region public

## This method is asynchronous.
## Fast flash the beam of desintegration.
func flash() -> void:

	if _flash_tween:
		push_error("Beam is already flashing...")
		return

	modulate.a = 0

	_flash_tween = create_tween()
	(_flash_tween
		.tween_property(self, "modulate:a", 1, _flasing_speed)
		.set_trans(Tween.TransitionType.TRANS_BOUNCE)
		.set_ease(Tween.EaseType.EASE_IN))

	await _flash_tween.finished

#endregion


#region static

static func make() -> DesintegrationBeam:
	var beam_instance = PRELOADED_SCENE.instantiate()
	return beam_instance

#endregion
