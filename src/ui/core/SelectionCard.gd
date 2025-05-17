class_name SelectionCard extends Control

signal selected

var _accent: Color
var _context

@export var _title_label: Label
@export var _header_texture: TextureRect
@export var _base_panel_container: PanelContainer

@onready var _select_button: Button = %"SelectButton"

#region built-in

func _ready() -> void:
	assert(_title_label, "Title label is not set")
	assert(_header_texture, "Header texture rect is not set")
	assert(_base_panel_container, "Panel container is not set")
	assert(_select_button, "Selection button is not set")
	
	_select_button.pressed.connect(_on_selection_button_pressed)

#endregion


#region public

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

#endregion


#region private

func _update_accent_elements(accent_color: Color) -> void:
	_title_label.add_theme_color_override("font_color", accent_color)
	var s = _base_panel_container.get_theme_stylebox("panel") as StyleBoxFlat
	s.shadow_color = accent_color

#endregion


#region event handlers

func _on_selection_button_pressed() -> void:
	selected.emit()

#endregion
