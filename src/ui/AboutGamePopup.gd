class_name AboutGamePopup extends AbstractPopup


#region constants

const PRELOADED_SCENE = preload("AboutGamePopup.tscn")

#endregion


#region fields

@export var _understand_button: Button

#endregion


#region builtins

func _ready() -> void:
	assert(_understand_button, "Close buttons is not set on AboutGamePopup")
	
	_understand_button.pressed.connect(_on_understand_button_pressed)

#endregion


#region event handlers

func _on_understand_button_pressed() -> void:
	close()

#endregion


#region static

static func make() -> AboutGamePopup:
	var popup_instance = PRELOADED_SCENE.instantiate()
	return popup_instance

#endregion
