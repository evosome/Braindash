class_name XPopup extends Control

@export var _content_container: Control
@export var _buttons_container: Control


#region public

## Get content container
func get_content() -> Control:
    return null


## Get buttons container, located in footer section of popup window
func get_buttons_container() -> Control:
    return null


## Shorthand for `get_buttons_container().add_child(...)`
func add_button(button: Button) -> void:
    pass

#endregion


#region static

static func make(content: Control, buttons: Array[Button]) -> void:
    pass

#endregion
