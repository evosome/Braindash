
class_name MenuScreen extends Screen

var _ctx: GameContext
var _subscreen_manager: ScreenManager
@export var _subscreen_container: Control
@export var _subscreen_manager_configurer: ScreenConfigurer


func _ready() -> void:
	assert(_subscreen_container, "Subscreeen container control is not set")
	
	_subscreen_manager = ScreenManager.on(_subscreen_container)
	_subscreen_manager.set_context(self)
	
	if _subscreen_manager_configurer:
		_subscreen_manager_configurer.configure(_subscreen_manager)


func on_enter(ctx: GameContext) -> void:
	_ctx = ctx


func get_subscreen_manager() -> ScreenManager:
	return _subscreen_manager


func get_global_context() -> GameContext:
	return _ctx
