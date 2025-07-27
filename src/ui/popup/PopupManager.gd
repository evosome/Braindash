class_name PopupManager extends Control


#region constants

const INFINITE_SHOW_TIME = -1

const DEFAULT_FADE_INOUT_TIME = 0.3
const DEFAULT_SHOW_TIME = 1.0

#endregion


var _custom_content: Control
var _appearing_tween: Tween

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


#region public

## This method is asynchronous. Show animation of popup appearing
## until the end and wait until the `time` is over to hide popup with outro animation.
func show_popup(content: Control, time: float = INFINITE_SHOW_TIME) -> void:

	if _custom_content:
		push_error("Popup is already showing")
		return
	
	if time < 0:
		push_error("Unable to set show time with negative value")
		return

	visible = true

	_custom_content = content
	_custom_content.scale = Vector2.ZERO

	_custom_content_holder.add_child(_custom_content)

	#TODO - add ability to create and set appear/disappear animations
	var appearing_tween = create_tween()
	_appearing_tween = appearing_tween

	appearing_tween.tween_property(_custom_content, "scale", Vector2.ONE, DEFAULT_FADE_INOUT_TIME).set_ease(Tween.EASE_IN)
	appearing_tween.tween_interval(time)
	appearing_tween.tween_property(_custom_content, "scale", Vector2.ZERO, DEFAULT_FADE_INOUT_TIME).set_ease(Tween.EASE_IN)

	await appearing_tween.finished

	close_popup()


## Show popup until it get closed with `close` method.
func open_popup(content: Control) -> void:
	
	if _custom_content:
		push_error("Popup is already showing")
		return

	visible = true

	_custom_content = content
	_custom_content.scale = Vector2.ZERO

	_custom_content_holder.add_child(_custom_content)

	var appearing_tween = create_tween()
	appearing_tween.tween_property(_custom_content, "scale", Vector2.ONE, DEFAULT_FADE_INOUT_TIME).set_ease(Tween.EASE_IN)


## Close current showing popup
func close_popup() -> void:

	if _appearing_tween && _appearing_tween.is_running():
		_appearing_tween.kill()

	visible = false
	_custom_content_holder.remove_child(_custom_content)
	_custom_content = null

#endregion
