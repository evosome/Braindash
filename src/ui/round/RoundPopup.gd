class_name RoundPopup extends Control

enum PopupBadge {
	CORRECT,
	WRONG,
	DRAW
}

const BADGE_TEXTURES = {
	PopupBadge.CORRECT: preload("res://assets/textures/ui/correct.png"),
	PopupBadge.WRONG: preload("res://assets/textures/ui/wrong.png"),
	#FIXME - change this texture to draw texture
	PopupBadge.DRAW: preload("res://assets/textures/ui/wrong.png")
}

@onready var _background: ColorRect = %"Background"
@onready var _badge_texture_rect: TextureRect = %"BadgeTexture"

@export var _animation_player: AnimationPlayer


#region builtin

func _ready() -> void:
	visible = false


func _process(_delta: float) -> void:
	if !visible:
		return

	_badge_texture_rect.pivot_offset.x = size.x / 2
	_badge_texture_rect.pivot_offset.y = size.y / 2

#endregion


#region public

## This method is asynchronous. Show animation of badge appearing
## until the end.
func show_popup(popup_badge: PopupBadge, speed: float = 0.5) -> void:
	var badge_texture = BADGE_TEXTURES[popup_badge]
	_badge_texture_rect.texture = badge_texture

	visible = true
	
	_animation_player.play("animation_pop")
	await _animation_player.animation_finished

	visible = false

#endregion
