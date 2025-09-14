class_name Arena extends Node

const YOUR_CHARACTER_TIP_PRELOADED = preload("res://src/ui/core/YourCharacterTip.tscn")

## Fired when any character (or even characters) on arena was died. Death information will be
## passed via `death_info` param. All characters can die
## at the same time, so the flag `all_died` (`is_all_died` getter on `CharacterDeathInfo`) of death info will be true.
signal characters_died(death_info: CharacterDeathInfo)

var _any_died: bool = false
var _last_death_info: CharacterDeathInfo
var _died_characters: Array[PlayerCharacter] = []
var _character_map: Dictionary[PlayerInfo, PlayerCharacter] = {}

@export var _camera: ArenaCamera
@export var _entities_container: Node

@export var _spawnpoints: Array[CharacterSpawnpoint]
@export var _line_of_ground: Path2D


#region builtin

func _process(_delta: float) -> void:

	# detect death of any character on each frame.
	if _any_died || _died_characters.size() == 0:
		return
	
	var characters = _character_map.values()
	#TODO - is it good idea to compare two arrays of characters using `all`?
	var death_info = CharacterDeathInfo.new(
		_died_characters,
		characters.all(func(c: PlayerCharacter): return _died_characters.has(c)))

	_any_died = true
	_last_death_info = death_info
	characters_died.emit(death_info)

#endregion


#region getter/setter

func is_any_died() -> bool:
	return _any_died


func get_last_death_info() -> CharacterDeathInfo:
	if !_any_died:
		push_warning("There are all characters alive on arena, so death info was not initialized...")
		return
	return _last_death_info


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


#TODO - maybe it's better to render tips on UI layer?
func show_tip_at(position: Vector2) -> void:
	var new_tip = YOUR_CHARACTER_TIP_PRELOADED.instantiate()
	new_tip.position = position
	add_child(new_tip)


func create_character_for(player: PlayerInfo, charater_type: CharacterType) -> PlayerCharacter:
	if _character_map.has(player):
		push_error("Character for the player was already assigned")
		return
	
	var spawnpoint = get_free_spawnpoint()
	var character = PlayerCharacter.spawn(self, spawnpoint, charater_type)

	# connect to death signal of health component and also bind event handler to receive
	# character ref.
	var character_health = character.get_health()
	character_health.died.connect(_on_character_died.bind(character))

	_character_map[player] = character
	return character


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

	winner_char.set_damage(smash_info.get_damage())
	winner_char.set_target(loser_chars[0])
	await winner_char.attack_target()


## Asynchronously show animations when nobody wins
func async_draw() -> void:
	pass

#endregion


#region event handlers


func _on_character_died(character: PlayerCharacter) -> void:
	# after burning this event handler, it will add character to the array of dead. After
	# any character was appended to this array, update (`_process`) cycle will detect,
	# that any character died, and fire `character_died` event.
	_died_characters.append(character)


#endregion


#region inner classes

class CharacterDeathInfo:

	var _died: Array[PlayerCharacter]
	var _all_died: bool

	func _init(died: Array[PlayerCharacter], all_died: bool) -> void:
		_died = died
		_all_died = all_died
	
	func is_all_died() -> bool:
		return false
	
	func get_died() -> Array[PlayerCharacter]:
		return _died

#endregion
