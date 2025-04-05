
extends Node

# initialize client (singleplayer) by default
# TODO: client/server core must be initialized from or args either config file
@onready var _client: GameClient = preload("res://src/client/GameClient.tscn").instantiate()


func _ready() -> void:
	# TODO: still set current round info this way, in next versions round info
	# can be set via config file or by selecting round in menu
	_client._context.set_current_round_info(preload("res://resources/rounds/6klass.tres"))
	add_child(_client)
