
class_name MenuScreen extends Screen

var _subscreen_manager: ScreenManager
@export var _subscreen_container: Control


func _ready() -> void:
	assert(_subscreen_container, "Subscreeen container control is not set")
	
	_subscreen_manager = ScreenManager.on(_subscreen_container)


func on_enter(ctx: GameContext) -> void:
	pass


func get_subscreen_manager() -> ScreenManager:
	return _subscreen_manager
