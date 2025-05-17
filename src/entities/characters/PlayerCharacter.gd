class_name PlayerCharacter extends Node2D

enum Animations {
	IDLE,
	ATTACK,
	HURT
}

const PLAYER_CHARACTER_PACKED = preload(
		"res://src/entities/characters/PlayerCharacter.tscn")

var _arena: RoundArena
var _damage_amount: int
var _target: PlayerCharacter
var _character_type: CharacterType
var _character_sprite: CharacterSprite

@export var _health_component: HealthComponent

#region built-in

func _ready() -> void:
	var packed_character_sprite = _character_type.packed_sprite
	if not packed_character_sprite:
		push_error("Character sprite is not set on character type")
		return

	_character_sprite = packed_character_sprite.instantiate()
	_character_sprite.attack_happened.connect(_on_sprite_attack_happened)
	add_child(_character_sprite)

#endregion


#region public

func get_type() -> CharacterType:
	return _character_type


func get_health() -> HealthComponent:
	return _health_component


func set_damage(value: int) -> void:
	_damage_amount = value


func get_damage() -> int:
	return _damage_amount


func set_target(other_player: PlayerCharacter) -> void:
	if self == other_player:
		push_error("Cannot assign self as target")
		return
	_target = other_player


func damage(amount: int) -> void:
	var current_health_amount = _health_component.get_health()
	_health_component.set_health(current_health_amount - amount)


func attack_target() -> void:
	if not _target:
		push_warning("No target assigned for this player")
		return
	_target.damage(_damage_amount)


func async_play_animation(animation: CharacterSprite.Animations) -> void:
	await _character_sprite.async_play_animation(animation)


func look_at_other(other: PlayerCharacter) -> void:
	var diff_to_other = other.position - position
	var diff_sign = sign(diff_to_other.x)
	var look_direction = (CharacterSprite.LookDirections.RIGHT
		if diff_sign > 0
		else CharacterSprite.LookDirections.LEFT)
	_character_sprite.look_at_direction(look_direction)

#endregion


#region event handlers

#TODO: Write state machine, instead of using code like this
func _on_sprite_attack_happened() -> void:
	attack_target()

#endregion


#region static

static func spawn(arena: RoundArena, position: Vector2, character_type: CharacterType) -> PlayerCharacter:
	var player_character = PLAYER_CHARACTER_PACKED.instantiate()
	player_character._arena = arena
	player_character._character_type = character_type
	player_character.position = position
	arena.spawn(player_character)
	return player_character

#endregion
