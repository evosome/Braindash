class_name SmashInfo


#region fields

var _damage: int
var _winner_char: PlayerCharacter
var _loser_chars: Array[PlayerCharacter]

#endregion


#region public

## Set, what damage will be dealed to loser characters
func set_damage(damage: int) -> void:
	_damage = damage


func get_damage() -> int:
	return _damage


## Set the character, who will smash loser character
func set_winner_character(player_character: PlayerCharacter) -> void:
	_winner_char = player_character


func get_winner_character() -> PlayerCharacter:
	return _winner_char


## Set the characters, who will be smashed by the winner. 
func set_loser_characters(player_character: Array[PlayerCharacter]) -> void:
	_loser_chars = player_character


func get_loser_characters() -> Array[PlayerCharacter]:
	return _loser_chars

#endregion
