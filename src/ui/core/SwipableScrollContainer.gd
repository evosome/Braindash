## Temporary solution for scrolling cards.
#TODO: write custom carousel widget
class_name SwipableScrollContainer extends ScrollContainer

@export var _touch_scroll_speed: float = 20.0
@export var _enable_mouse_support: bool = true

var _touched: bool = false
var touch_prev_position := Vector2()

#region built-in

func _input(event):
	_handle_screen_draggin(event)
	if _enable_mouse_support:
		_handle_mouse_draggin(event)

#endregion


#region private

func _handle_screen_draggin(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		var screen_drag_event = event as InputEventScreenDrag
		_do_scroll(screen_drag_event.position)


func _handle_mouse_draggin(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event = event as InputEventMouseButton
		_touched = event.pressed

	if event is InputEventMouseMotion && _touched:
		var mouse_motion_event = event as InputEventMouseMotion
		_do_scroll(mouse_motion_event.position)


func _do_scroll(position: Vector2) -> void:
	var delta = (position - touch_prev_position).normalized()
	set_h_scroll(get_h_scroll() - delta.x * _touch_scroll_speed)
	set_v_scroll(get_v_scroll() - delta.y * _touch_scroll_speed)
	touch_prev_position = position

#endregion
