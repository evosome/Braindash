class_name RoundArena extends Node

@export var _camera: Camera2D
@export var _entities_container: Node

@export var _spawnpoints: Array[Node2D]


func spawn(entity: Node) -> void:
	_entities_container.add_child(entity)


func despawn(entity: Node) -> void:
	_entities_container.remove_child(entity)


func get_camera() -> Camera2D:
	return _camera


func get_entities() -> Array[Node]:
	return _entities_container.get_children()


func get_free_spawnpoint_position() -> Vector2:
	var node: Node2D = _spawnpoints.pop_front()
	return node.position


## This method is asynchronous.
## Asynchronously show animations of smashing loser by winner.
func async_smash(smash_info: SmashInfo) -> void:
	
	#TODO: maybe animate this by AnimationPlayer node?
	
	var winner_char = smash_info.get_winner_character()
	var loser_char = smash_info.get_loser_characters()
	
	await winner_char.async_play_animation(CharacterSprite.Animations.ATTACK)


## Asynchronously show animations when nobody wins
func async_on_draw() -> void:
	pass
