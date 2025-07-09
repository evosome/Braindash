
class_name GameContext

var _me: PlayerInfo
var _enemy: PlayerInfo
var _current_screen_name: String
var _current_round_info: RoundInfo
var _grades: Array[Grade]
var _current_grade: Grade
var _screen_manager: ScreenManager
var _enemy_character_type: CharacterType
var _my_character_type: CharacterType
var _available_characters: Array[CharacterType]


#region builtin

func _init(screen_manager: ScreenManager) -> void:
	_screen_manager = screen_manager

#endregion


#region public

func switch_screen(screen_name: String) -> void:
	_screen_manager.switch(screen_name)


func has_round_info() -> bool:
	return _current_round_info != null


#TODO: rename this method into `get_game_info`
func get_current_round_info() -> RoundInfo:
	return _current_round_info


#TODO: rename this method into `set_game_info`
func set_current_round_info(value: RoundInfo) -> void:
	_current_round_info = value


func get_current_screen_name() -> String:
	return _current_screen_name


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


func set_my_character_type(value: CharacterType) -> void:
	_my_character_type = value


func get_my_character_type() -> CharacterType:
	return _my_character_type


func set_enemy_character_type(value: CharacterType) -> void:
	_enemy_character_type = value


func get_enemy_character_type() -> CharacterType:
	return _enemy_character_type


func set_available_characters(characters: Array[CharacterType]) -> void:
	_available_characters = characters


func get_available_characters() -> Array[CharacterType]:
	return _available_characters

#endregion
