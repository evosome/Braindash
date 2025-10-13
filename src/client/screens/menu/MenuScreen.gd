class_name MenuScreen extends Screen


#region constants

#TODO - use preloads from registry
const GRADE_SELECTION_SUBSCREEN = preload(
		"res://src/client/screens/menu/subscreens/ClassSelectionSubscreen.tscn")
const TOPIC_SEELCTION_SUBSCREEN = preload(
		"res://src/client/screens/menu/subscreens/TopicSelectionSubscreen.tscn")
const MAIN_SUBSCREEN = preload("res://src/client/screens/menu/subscreens/MainSubscreen.tscn")
const CHARACTER_SELECTION_SUBSCREEN = preload(
		"res://src/client/screens/menu/subscreens/CharacterSelectionSubscreen.tscn")

#endregion


#region fields

var _subscreen_manager: ScreenManager

@export var _subscreen_container: Control

#endregion


#region services

@onready var _popup_manager = ServiceLocator.get_of(AbstractPopupManager) as AbstractPopupManager

#endregion


#region builtins

func _ready() -> void:
	assert(_subscreen_container, "Subscreeen container (Control) is not set on MenuScreen class")
	
	_subscreen_manager = ScreenManager.on(_subscreen_container)
	_subscreen_manager.register("grades", GRADE_SELECTION_SUBSCREEN)
	_subscreen_manager.register("topics", TOPIC_SEELCTION_SUBSCREEN)
	_subscreen_manager.register("main", MAIN_SUBSCREEN)
	_subscreen_manager.register("characters", CHARACTER_SELECTION_SUBSCREEN)
	_subscreen_manager.register("game_results", GameResultsSubscreen.PRELOADED_SCENE)

#endregion


#region virtuals

func on_enter(ctx: SharedContext) -> void:
	_subscreen_manager.set_context(ctx)
	_subscreen_manager.switch("main")

	var is_game_over = ctx.is_game_over
	if !is_game_over:
		return
	
	var last_game_result = ctx.last_game_result

	var game_result_popup = GameResultInfo.make_from_result(last_game_result)
	_popup_manager.open_popup(game_result_popup)

#endregion
