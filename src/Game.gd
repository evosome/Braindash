extends Node


# initialize client (singleplayer) by default
# TODO: client/server core must be initialized from either args or config file
@onready var _client: GameClient = preload("res://src/client/GameClient.tscn").instantiate()


#region builtins

func _ready() -> void:
	add_child(_client)

#endregion
