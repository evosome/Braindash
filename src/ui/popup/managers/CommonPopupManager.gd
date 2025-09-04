## Class used for managing popup showing and ordering.
class_name CommonPopupManager extends AbstractPopupManager


#region fields

var _current_popup: AbstractPopup

@export var _background: ColorRect
@export var _pop_up_animation_player: AnimationPlayer
@export var _custom_content_holder: Control

#region fields


#region builtin

func _ready() -> void:
	assert(_background, "Background node is not set on CommonPopupManager")
	assert(_custom_content_holder, "Custom content holder is not set on CommonPopupManager")
	assert(_pop_up_animation_player, "Pop up animation player is not set on CommonPopupManager")

	visible = false


func _process(_delta: float) -> void:

	_custom_content_holder.pivot_offset = _custom_content_holder.size / 2

	if !visible || !_current_popup:
		return

	# TODO: use some other method to centrify the appearing popup, as it is a bit laggy
	_centrify_content()

#endregion


#region private

func _centrify_content() -> void:
	_custom_content_holder.position = size / 2 - _current_popup.size / 2

#endregion


#region public

func open_popup(popup: AbstractPopup) -> void:
	visible = true
	
	_pop_up_animation_player.play("popup")
	await _pop_up_animation_player.animation_finished

	_current_popup = popup
	_centrify_content()

	popup.open(_custom_content_holder)
	popup.closed.connect(_on_popup_closed.bind(popup))

#endregion


#region event handlers

func _on_popup_closed(popup: AbstractPopup) -> void:
	visible = false
	_current_popup = null
	popup.closed.disconnect(_on_popup_closed)

#endregion
