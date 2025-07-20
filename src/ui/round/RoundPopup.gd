class_name RoundPopup extends Control

enum PopupBadge {
	CORRECT,
	WRONG,
	DRAW,

	#TODO - move win and lose popups to different widget, that also will display
	# game statistics and result.
	WIN,
	LOSE
}

@onready var _background: ColorRect = %"Background"
@onready var _badge_texture_rect: TextureRect = %"BadgeTexture"

@export var _animation_player: AnimationPlayer
@export var _badge_textures: Dictionary[PopupBadge, Texture2D]


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
	var badge_texture = _badge_textures[popup_badge]
	_badge_texture_rect.texture = badge_texture

	visible = true
	
	_animation_player.play("animation_pop")
	await _animation_player.animation_finished

	visible = false

#endregion
