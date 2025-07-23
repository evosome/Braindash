class_name RoundPopup extends Control


#region constants

const INFINITE_SHOW_TIME = -1

const DEFAULT_FADE_INOUT_TIME = 0.3
const DEFAULT_SHOW_TIME = 1.0

#endregion


var _custom_content: Control
var _appearing_tween: Tween
var _show_time: float = DEFAULT_SHOW_TIME

@export var _custom_content_holder: Control


#region builtin

func _ready() -> void:
	visible = false


func _process(_delta: float) -> void:
	if !visible || !_custom_content:
		return

	_custom_content.pivot_offset = _custom_content.size / 2
	_custom_content.position = _custom_content_holder.size / 2 - _custom_content.size / 2

#endregion


func set_show_time(value: float) -> void:
	_show_time = value


func get_show_time() -> float:
	return _show_time


#region public

## This method is asynchronous. Show animation of popup appearing
## until the end. You're able to set your custom content of appearing popup.
func show_popup(content: Control) -> void:

	if _appearing_tween:
		push_error("Popup is already showing")
		return

	_custom_content = content
	_custom_content_holder.add_child(content)

	visible = true

	_custom_content.scale = Vector2.ZERO

	var appearing_tween = create_tween()
	appearing_tween.tween_property(_custom_content, "scale", Vector2.ONE, DEFAULT_FADE_INOUT_TIME).set_ease(Tween.EASE_IN)

	if _show_time < 0:
		await appearing_tween.finished
		return

	appearing_tween.tween_interval(_show_time)
	appearing_tween.tween_property(_custom_content, "scale", Vector2.ZERO, DEFAULT_FADE_INOUT_TIME).set_ease(Tween.EASE_IN)

	await appearing_tween.finished

	visible = false

	_custom_content = null
	_custom_content_holder.remove_child(content)

#endregion
