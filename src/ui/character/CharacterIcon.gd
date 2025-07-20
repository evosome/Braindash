class_name CharacterIcon extends Control

signal clicked

@export var _icon_button: Button


#region built-in

func _ready() -> void:
	_icon_button.pressed.connect(_on_icon_button_pressed)

#endregion


#region public

func set_icon_texture(icon_texture: Texture2D) -> void:
	_icon_button.icon = icon_texture

#endregion


#region event handlers

func _on_icon_button_pressed() -> void:
	clicked.emit()

#endregion
