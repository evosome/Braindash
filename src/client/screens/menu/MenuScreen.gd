
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
	_subscreen_manager.register("game_results", GameResultsSubscreen.PRELOADED_SCENE)


func on_enter(ctx: GameContext) -> void:
	_menu_context = MenuContext.new(_subscreen_manager, ctx)
	_subscreen_manager.set_context(_menu_context)
	_subscreen_manager.switch("main")

	var is_game_over = ctx.is_game_over
	if !is_game_over:
		return
	
	var last_game_result = ctx.last_game_result
	var popup_manager = ctx.get_popup_manager()

	var game_result_popup = GameResultInfo.make_from_result(last_game_result)
	popup_manager.open_popup(game_result_popup)


func get_subscreen_manager() -> ScreenManager:
	return _subscreen_manager
