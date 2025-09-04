class_name RoundResultBadge extends Control


#region constants

const PRELOADED_SCENE = preload("RoundResultBadge.tscn")

#endregion


enum PopupBadges {
	CORRECT,
	WRONG,
	DRAW
}

var _current_badge: PopupBadges

@export var _texture_rect: TextureRect
@export var _badge_textures: Dictionary[PopupBadges, Texture2D]
@export var _fallback_badge_texture: Texture2D


#region public

func set_badge(value: PopupBadges) -> void:
	_current_badge = value
	_texture_rect.texture = _badge_textures.get(value, _fallback_badge_texture)


func get_badge() -> PopupBadges:
	return _current_badge

#endregion


#region static

static func make_with_texture(badge_texture: PopupBadges) -> RoundResultBadge:
	var instantiated_result_badge = PRELOADED_SCENE.instantiate()
	instantiated_result_badge.set_badge(badge_texture)
	return instantiated_result_badge

#endregion
