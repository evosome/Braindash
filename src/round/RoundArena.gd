class_name RoundArena extends Node

@export var _camera: Camera2D
@export var _entities_container: Node

@export var _left_player_position: Node2D
@export var _right_player_position: Node2D


func spawn(entity: Node) -> void:
	_entities_container.add_child(entity)


func despawn(entity: Node) -> void:
	_entities_container.remove_child(entity)


func get_camera() -> Camera2D:
	return _camera


func get_entities() -> Array[Node]:
	return _entities_container.get_children()


func get_left_player_position() -> Vector2:
	return _left_player_position.position


func get_right_player_position() -> Vector2:
	return _right_player_position.position
