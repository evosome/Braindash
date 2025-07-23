class_name ArenaCamera extends Camera2D

var _following_target: Node2D
var _default_zoom_value: Vector2
var _default_offset: Vector2
var _zoom_in_tween: Tween
var _shaking_tween: Tween


#region builtin

func _ready() -> void:
	_default_zoom_value = zoom
	_default_offset = offset


func _process(_delta: float) -> void:
	if _following_target:
		position = _following_target.position

#endregion


#region getter/setter


func get_default_position() -> Vector2:
	return Vector2.ZERO


func set_following_target(node2d: Node2D) -> void:
	_following_target = node2d

#endregion


#region public

## This method is asynchronous. Zoom camera in at the given point with the zoom value
func zoom_in(at_position: Vector2, zoom_value: float, speed: float = 0.5) -> void:

	if _zoom_in_tween:
		push_warning("Camera is already zooming in")
		return

	var zoom_in_tween = create_tween()
	zoom_in_tween.parallel().tween_property(self, "zoom", Vector2.ONE * zoom_value, speed)
	zoom_in_tween.parallel().tween_property(self, "position", at_position, speed)
	_zoom_in_tween = zoom_in_tween

	await zoom_in_tween.finished

	_zoom_in_tween = null


## This method is asynchronous. Zoom camera back at zero point and set default zoom
func zoom_off(speed: float = 0.5) -> void:
	
	if _zoom_in_tween:
		push_warning("Camera is already zooming off")
		return

	var zoom_in_tween = create_tween()
	zoom_in_tween.parallel().tween_property(self, "zoom", _default_zoom_value, speed)
	zoom_in_tween.parallel().tween_property(self, "position", Vector2.ZERO, speed)
	_zoom_in_tween = zoom_in_tween

	await zoom_in_tween.finished

	_zoom_in_tween = null


## This method is asynchronous. Shake camera with the certain shaking power and time of shaking
func shake(shake_power: float, shake_time: float) -> void:

	#TODO: kill shaking tween and coroutine, instead of pushing warnings
	if _shaking_tween:
		push_warning("Camera is already shaking")
		return
	
	var shaking_tween = create_tween()
	shaking_tween.tween_method(
		func(_v): offset = Vector2(randf() * shake_power, randf() * shake_power),
		0.0,
		1.0,
		shake_time)
	_shaking_tween = shaking_tween

	await shaking_tween.finished

	_shaking_tween = null
	offset = _default_offset

#endregion
