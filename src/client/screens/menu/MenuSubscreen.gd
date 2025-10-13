@abstract
class_name MenuSubscreen extends Screen


#region services

@onready var _screen_manager = ServiceLocator.get_of(ScreenManager) as ScreenManager

#endregion


#region abstract

@abstract func on_enter(ctx: SharedContext) -> void

#endregion


#region public

## Switch global screens (not subscreens)
func switch_global(name: String) -> void:
	_screen_manager.switch(name)

#endregion
