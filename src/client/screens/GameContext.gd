
class_name GameContext extends Object

signal screen_changed(screen_name: String)

var _me: PlayerInfo
var _enemy: PlayerInfo
var _current_screen_name: String
var _current_round_info: RoundInfo
var _grades: Array[Grade]
var _current_grade: Grade


func has_round_info() -> bool:
	return _current_round_info != null


func get_current_round_info() -> RoundInfo:
	return _current_round_info


func set_current_round_info(value: RoundInfo) -> void:
	_current_round_info = value


func get_current_screen_name() -> String:
	return _current_screen_name


func switch_screen(screen_name: String) -> void:
	_current_screen_name = screen_name
	screen_changed.emit(screen_name)


func get_me() -> PlayerInfo:
	return _me


func set_me(player: PlayerInfo) -> void:
	_me = player


func get_enemy() -> PlayerInfo:
	return _enemy


func set_enemy(player: PlayerInfo) -> void:
	_enemy = player


func set_grades(grades: Array[Grade]) -> void:
	_grades = grades


func get_grades() -> Array[Grade]:
	return _grades


func set_current_grade(grade: Grade) -> void:
	_current_grade = grade


func get_current_grade() -> Grade:
	return _current_grade
