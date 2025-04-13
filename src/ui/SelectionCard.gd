class_name SelectionCard extends Control

var _accent: Color

@export var _title_label: Label
@export var _header_texture: TextureRect
@export var _base_panel_container: PanelContainer


func _ready() -> void:
	assert(_title_label, "Title label is not set")
	assert(_header_texture, "Header texture rect is not set")
	assert(_base_panel_container, "Panel container is not set")
	
	set_accent_color(Color.AQUA)


func set_header_texture(texture: Texture2D) -> void:
	_header_texture.texture = texture


func set_accent_color(color: Color) -> void:
	_accent = color
	_update_accent_elements(_accent)


func _update_accent_elements(accent_color: Color) -> void:
	_title_label.add_theme_color_override("font_color", accent_color)
	var s = _base_panel_container.get_theme_stylebox("panel") as StyleBoxFlat
	s.shadow_color = accent_color
