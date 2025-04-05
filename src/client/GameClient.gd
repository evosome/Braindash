class_name GameClient extends Node

var _context: GameContext = GameContext.new()

@export var _screens_configurer: ScreenConfigurer

@onready var _screen_manager: ScreenManager = ScreenManager.on(self)


func _ready() -> void:
	_screen_manager.set_context(_context)
	if _screens_configurer:
		_screens_configurer.configure(_screen_manager)
	
	_context.screen_changed.connect(
		func(screen_name: String):
			_screen_manager.switch(screen_name))
