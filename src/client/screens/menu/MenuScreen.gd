
class_name MenuScreen extends Screen

const GRADE_SELECTION_SUBSCREEN = preload(
		"res://src/client/screens/menu/ClassSelectionSubscreen.tscn")
const TOPIC_SEELCTION_SUBSCREEN = preload(
		"res://src/client/screens/menu/TopicSelectionSubscreen.tscn")
const MAIN_SUBSCREEN = preload("res://src/client/screens/menu/MainSubscreen.tscn")
const CHARACTER_SELECTION_SUBSCREEN = preload(
		"res://src/client/screens/menu/CharacterSelectionSubscreen.tscn")

var _menu_context: MenuContext
var _subscreen_manager: ScreenManager
@export var _subscreen_container: Control
@export var _subscreen_manager_configurer: ScreenConfigurer


func _ready() -> void:
	assert(_subscreen_container, "Subscreeen container control is not set")
	
	_subscreen_manager = ScreenManager.on(_subscreen_container)
	_subscreen_manager.register("grades", GRADE_SELECTION_SUBSCREEN)
	_subscreen_manager.register("topics", TOPIC_SEELCTION_SUBSCREEN)
	_subscreen_manager.register("main", MAIN_SUBSCREEN)
	_subscreen_manager.register("characters", CHARACTER_SELECTION_SUBSCREEN)


func on_enter(ctx: GameContext) -> void:
	_menu_context = MenuContext.new(_subscreen_manager, ctx)
	_subscreen_manager.set_context(_menu_context)
	_subscreen_manager.switch("main")


func get_subscreen_manager() -> ScreenManager:
	return _subscreen_manager
