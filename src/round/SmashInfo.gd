class_name SmashInfo

var _damage: int
var _winner_char: PlayerCharacter
var _loser_chars: Array[PlayerCharacter]


#region public

func set_damage(damage: int) -> void:
	_damage = damage


func get_damage() -> int:
	return _damage


func set_winner_character(player_character: PlayerCharacter) -> void:
	_winner_char = player_character


func get_winner_character() -> PlayerCharacter:
	return _winner_char


func set_loser_characters(player_character: Array[PlayerCharacter]) -> void:
	_loser_chars = player_character


func get_loser_characters() -> Array[PlayerCharacter]:
	return _loser_chars

#endregion
