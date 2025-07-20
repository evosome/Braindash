class_name PlayerCharacter extends Node2D

enum Animations {
	IDLE,
	ATTACK,
	HURT
}

const PLAYER_CHARACTER_PACKED = preload(
		"res://src/entities/characters/PlayerCharacter.tscn")

var _arena: Arena
var _damage_amount: int
var _target: PlayerCharacter
var _character_type: CharacterType
var _character_sprite: CharacterSprite
var _attack_type: AttackType

@export var _health_component: HealthComponent

#region built-in

func _ready() -> void:
	var packed_character_sprite = _character_type.packed_sprite
	if not packed_character_sprite:
		push_error("Character sprite is not set on character type")
		return

	_attack_type = _character_type.get_attack_type()
	_character_sprite = packed_character_sprite.instantiate()
	add_child(_character_sprite)

	async_play_animation(CharacterSprite.Animations.IDLE)

#endregion


#region getter/setter

func get_type() -> CharacterType:
	return _character_type


func get_health() -> HealthComponent:
	return _health_component


func get_sprite() -> CharacterSprite:
	return _character_sprite


func set_damage(value: int) -> void:
	_damage_amount = value


func get_damage() -> int:
	return _damage_amount


func set_target(other_player: PlayerCharacter) -> void:
	if self == other_player:
		push_error("Cannot assign self as target")
		return
	_target = other_player

#endregion


#region public

func damage(amount: int) -> void:
	var current_health_amount = _health_component.get_health()
	_health_component.set_health(current_health_amount - amount)


## This method is asynchronous.
func attack_target() -> void:
	if not _target:
		push_warning("No target assigned for this player")
		return
	await _attack_type.perform(_arena, self, _target)


func async_play_animation(animation: CharacterSprite.Animations) -> void:
	await _character_sprite.async_play_animation(animation)


func look_at_other(other: PlayerCharacter) -> void:
	var diff_to_other = other.position - position
	var diff_sign = sign(diff_to_other.x)
	var look_direction = (CharacterSprite.LookDirections.RIGHT
		if diff_sign > 0
		else CharacterSprite.LookDirections.LEFT)
	_character_sprite.look_at_direction(look_direction)


func look_at_direction(direction: CharacterSprite.LookDirections) -> void:
	_character_sprite.look_at_direction(direction)

#endregion


#region static

static func spawn(
		arena: Arena,
		spawnpoint: CharacterSpawnpoint,
		character_type: CharacterType) -> PlayerCharacter:
	var player_character = PLAYER_CHARACTER_PACKED.instantiate()
	player_character._arena = arena
	player_character._character_type = character_type
	arena.spawn_character_at(player_character, spawnpoint)
	return player_character

#endregion
