class_name Arena extends Node

var _character_map: Dictionary[PlayerInfo, PlayerCharacter] = {}

@export var _camera: ArenaCamera
@export var _entities_container: Node

@export var _spawnpoints: Array[CharacterSpawnpoint]
@export var _line_of_ground: Path2D


#region getter/setter

func get_camera() -> ArenaCamera:
	return _camera


func get_entities() -> Array[Node]:
	return _entities_container.get_children()


func get_free_spawnpoint_position() -> Vector2:
	var node: Node2D = _spawnpoints.pop_front()
	return node.position


func get_free_spawnpoint() -> CharacterSpawnpoint:
	return _spawnpoints.pop_front()


func get_character_of(player: PlayerInfo) -> PlayerCharacter:
	var found_player = _character_map.get(player)
	if !found_player:
		push_error(
				"Character of the specified player(",
				player.to_string(),
				") was not found. Returning null...")
	return found_player


func get_characters_of(players: Array[PlayerInfo]) -> Array[PlayerCharacter]:
	var chatacters: Array[PlayerCharacter]
	var resolved_characters = players.map(func(p: PlayerInfo): return _character_map.get(p))
	chatacters.assign(resolved_characters)
	return chatacters


## Line of ground represented as 2D curve
func get_curve_of_ground() -> Curve2D:
	return _line_of_ground.curve

#endregion


#region public

func create_character_for(player: PlayerInfo, charater_type: CharacterType) -> void:
	if _character_map.has(player):
		push_error("Character for the player was already assigned")
		return
	var spawnpoint = get_free_spawnpoint()
	var character = PlayerCharacter.spawn(self, spawnpoint, charater_type)
	_character_map[player] = character


func spawn(entity: Node) -> void:
	_entities_container.add_child(entity)


func spawn_character_at(character: PlayerCharacter, spawnpoint: CharacterSpawnpoint) -> void:
	character.set_position(spawnpoint.get_position())
	character.set_scale(Vector2.ONE * spawnpoint.get_character_distance())
	spawn(character)
	character.look_at_direction(spawnpoint.get_character_look_direction())


func despawn(entity: Node) -> void:
	_entities_container.remove_child(entity)


## This method is asynchronous.
## Asynchronously show animations of smashing loser by winner.
func async_smash(smash_info: SmashInfo) -> void:
	
	var winner_char = smash_info.get_winner_character()
	var loser_chars = smash_info.get_loser_characters()

	winner_char.set_target(loser_chars[0])
	await winner_char.attack_target()


## Asynchronously show animations when nobody wins
func async_draw() -> void:
	pass

#endregion
