class_name GameClient extends Node


#region fields

var _context: GameContext
var _screen_manager: ScreenManager

@export var _popup_manager: AbstractPopupManager
@export var _screen_manager_container: Control

#endregion


#region builtin

func _ready() -> void:

	assert(_popup_manager != null, "Popup manager is not set on GameClient")
	assert(_screen_manager_container != null, "Screen manager container is not set on GameClient")
	
	_screen_manager = ScreenManager.on(_screen_manager_container)

	_context = GameContext.new(self)
	_screen_manager.set_context(_context)
	_context.set_me(PlayerInfo.new())
	_context.set_enemy(PlayerInfo.new())
	_screen_manager.register("intro", preload("screens/Intro.tscn"))
	_screen_manager.register("menu", preload("screens/menu/MenuScreen.tscn"))
	_screen_manager.register("round", preload("singleplayer/SingleplayerGameScreen.tscn"))
	_screen_manager.switch("intro")

#endregion


#region getter/setter

func get_context() -> GameContext:
	return _context


func get_screen_manager() -> ScreenManager:
	return _screen_manager


func get_popup_manager() -> AbstractPopupManager:
	return _popup_manager

#endregion
