class_name PlayerCharacter extends Node

var _character_type: CharacterType

@export var _character_sprite: CharacterSprite
@export var _health_component: HealthComponent

#region built-in

func _init(character_type: CharacterType) -> void:
	_character_type = character_type


func _ready() -> void:
	var character_spritesheet = _character_type.spritesheet
	if character_spritesheet:
		_character_sprite.sprite_frames = character_spritesheet
	else:
		push_error("Character spritesheet is not set on its type")

#endregion


#region public


func get_type() -> CharacterType:
	return _character_type


func get_health() -> HealthComponent:
	return _health_component


func get_sprite() -> CharacterSprite:
	return _character_sprite

#endregion
