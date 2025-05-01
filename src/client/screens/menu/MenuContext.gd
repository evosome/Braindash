class_name MenuContext

var _current_grade: Grade
var _game_context: GameContext
var _subscreen_manager: ScreenManager


#region built-ins

func _init(subscreen_manager: ScreenManager, game_context: GameContext) -> void:
	_subscreen_manager = subscreen_manager
	_game_context = game_context

#endregion


#region public


func get_grades() -> Array[Grade]:
	return _game_context.get_grades()


func set_current_grade(grade: Grade) -> void:
	_current_grade = grade
	_game_context.set_current_grade(grade)


func get_current_grade() -> Grade:
	return _current_grade


func set_current_round_info(round_info: RoundInfo) -> void:
	_game_context.set_current_round_info(round_info)


func switch_screen(screen_name: String) -> void:
	_game_context.switch_screen(screen_name)


func switch_subscreen(subscreen_name: String) -> void:
	_subscreen_manager.switch(subscreen_name)

#endregion
