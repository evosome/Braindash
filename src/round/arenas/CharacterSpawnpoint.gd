class_name CharacterSpawnpoint extends Node2D

@export var _character_look_direction: CharacterSprite.LookDirections
@export var _character_distance: float


#region public

func get_character_look_direction() -> CharacterSprite.LookDirections:
	return _character_look_direction


## Get character distance to camera (z coord on arena).
func get_character_distance() -> float:
	return _character_distance

#endregion
