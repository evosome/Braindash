class_name CommonPopup extends AbstractPopup


#region fields

var _content: Control

@export var _title_label: Label
@export var _content_container: Control
@export var _buttons_container: Control

#endregion


#region builtin

func _ready() -> void:
	assert(_title_label != null, "Title label is not set on CommonPopup")
	assert(_content_container != null, "Content container is not set on CommonPopup")
	assert(_buttons_container != null, "Buttons container is not set on CommonPopup")

#endregion


#region public

func get_title() -> String:
	return _title_label.text


func set_title(title: String) -> void:
	_title_label.text = title


func get_content() -> Control:
	return _content


func set_content(content: Control) -> void:

	if _content:
		_content_container.remove_child(_content)

	_content = content
	add_child(_content)


func get_buttons_container() -> Control:
	return _buttons_container

#endregion
