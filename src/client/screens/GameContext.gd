
class_name GameContext extends Object

signal screen_changed(screen_name: String)

var _current_screen_name: String
var _current_round_info: RoundInfo


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
