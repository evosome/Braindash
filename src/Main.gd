
extends Node

# TODO: grades must be read from file, when game is loading
@export var _grades: Array[Grade]

# TODO: characters must be read from file, when game is loading
@export var _characters: Array[CharacterType]

# initialize client (singleplayer) by default
# TODO: client/server core must be initialized from or args either config file
@onready var _client: GameClient = preload("res://src/client/GameClient.tscn").instantiate()


func _ready() -> void:
	add_child(_client)
	var context = _client.get_context()
	context.set_grades(_grades)
	context.set_available_characters(_characters)
