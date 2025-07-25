class_name GameClient extends Node

var _context: GameContext
var _screen_manager: ScreenManager


func _ready() -> void:
	
	_screen_manager = ScreenManager.on(self)

	var user_data = UserData.new()
	_context = GameContext.new(_screen_manager, user_data)
	_screen_manager.set_context(_context)
	_context.set_me(PlayerInfo.new())
	_context.set_enemy(PlayerInfo.new())
	_screen_manager.register("menu", preload("res://src/client/screens/menu/MenuScreen.tscn"))
	_screen_manager.register("round", preload("res://src/client/singleplayer/SingleplayerGameScreen.tscn"))
	_screen_manager.switch("menu")


func get_context() -> GameContext:
	return _context
