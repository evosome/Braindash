## Describes spawnpoint of game characters.
class_name CharacterSpawnpoint extends Node2D


#region fields

@export var _character_look_direction: CharacterSprite.LookDirections
@export var _character_distance: float

#endregion


#region public

func get_character_look_direction() -> CharacterSprite.LookDirections:
	return _character_look_direction


## Get character distance to camera (affects scale of characters).
func get_character_distance() -> float:
	return _character_distance

#endregion
