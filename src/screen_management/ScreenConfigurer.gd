
class_name ScreenConfigurer extends Resource

@export var _screens: Dictionary[String, PackedScene]
@export var _current_screen_name: String


func configure(screen_manager: ScreenManager) -> void:
	for screen_name in _screens:
		screen_manager.register(screen_name, _screens[screen_name])
	screen_manager.switch(_current_screen_name)
