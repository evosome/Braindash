## Represents client game core with client-side services registered.
class_name GameClient extends Node


#region fields

@export var _popup_manager: AbstractPopupManager
@export var _screen_manager_container: Control

@onready var _user_data: UserData = UserData.new()
@onready var _screen_manager: ScreenManager = ScreenManager.on(_screen_manager_container)

#endregion


#region builtin

func _ready() -> void:

	assert(_popup_manager != null, "Popup manager is not set on GameClient")
	assert(_screen_manager_container != null, "Screen manager container is not set on GameClient")

	# Register ScreenManager instance (v0.2)
	ServiceLocator.register(ScreenManager, _screen_manager)

	#TODO - move registering scenes to export
	var context = SharedContext.new()
	_screen_manager.set_context(context)
	_screen_manager.register("intro", preload("screens/Intro.tscn"))
	_screen_manager.register("menu", preload("screens/menu/MenuScreen.tscn"))
	_screen_manager.register("round", preload("singleplayer/SingleplayerGameScreen.tscn"))
	_screen_manager.switch("intro")

	# Register PopupManager instance (v0.2)
	ServiceLocator.register(AbstractPopupManager, _popup_manager)

	# Register UserData instance (v0.2)
	ServiceLocator.register(UserData, _user_data)

#endregion


#region getter/setter

func get_screen_manager() -> ScreenManager:
	return _screen_manager


func get_popup_manager() -> AbstractPopupManager:
	return _popup_manager

#endregion
