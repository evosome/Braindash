class_name SelectionCard extends Control

signal selected

var _accent: Color
var _context

@export var _base_panel_container: PanelContainer
@export var _texture_panel_container: PanelContainer
@export var _title_label: Label
@export var _header_texture: TextureRect
@export var _select_button: Button

#region container exports
# Braindash card includes four sections: texture header,
# text header, content and footer. You can access any of these
# by the getter presented in the `getter/setter` section below.

@export var _texture_header_container: Control
@export var _header_container: Control
@export var _content_container: Control
@export var _footer_contaienr: Control

#endregion


#region built-in

func _ready() -> void:
	assert(_title_label, "Title label is not set")
	assert(_header_texture, "Header texture rect is not set")
	assert(_base_panel_container, "Base panel container is not set")
	assert(_texture_panel_container, "Texture panel container is not set")
	assert(_select_button, "Selection button is not set")
	
	_select_button.pressed.connect(_on_selection_button_pressed)

#endregion


#region getter/setter

func set_title(value: String) -> void:
	_title_label.text = value


func set_header_texture(texture: Texture2D) -> void:
	_header_texture.texture = texture


func set_accent_color(color: Color) -> void:
	_accent = color
	_update_accent_elements(_accent)


func set_context(value) -> void:
	_context = value


func get_context():
	return _context


func get_texture_header() -> Control:
	return _texture_header_container


func get_header() -> Control:
	return _header_container


func get_content() -> Control:
	return _content_container


func get_footer() -> Control:
	return _footer_contaienr

#endregion


#region private

func _update_accent_elements(accent_color: Color) -> void:
	_title_label.add_theme_color_override("font_color", accent_color)

	var base_stylebox = _base_panel_container.get_theme_stylebox("panel") as StyleBoxFlat
	base_stylebox.shadow_color = accent_color

	var texture_stylebox = _texture_panel_container.get_theme_stylebox("panel") as StyleBoxFlat
	texture_stylebox.bg_color = accent_color

#endregion


#region event handlers

func _on_selection_button_pressed() -> void:
	selected.emit()

#endregion
