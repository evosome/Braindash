class_name RoundCountPopup extends Control


#region constants

const ROUND_COUNTER_TEXT = "Раунд {0}"

#endregion

@export var _animation_player: AnimationPlayer
@export var _round_counter_label: Label


#region builtin

func _ready() -> void:
	visible = false

#endregion


#region public

## This method is asynchronous. Async show animation of fading in round count label.
func show_popup(round_count: int) -> void:

	visible = true

	_round_counter_label.text = ROUND_COUNTER_TEXT.format([round_count])

	_animation_player.play("appear")
	await _animation_player.animation_finished

	visible = false

#endregion
