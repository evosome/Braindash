class_name GameResultsList extends Control


#region signals

## Fired, when game result about to be examined by user
signal game_result_metadata_examined(metadata: GameResultMetadata)

#endregion


#region constants

const PRELOADED_SCENE = preload("GameResultsList.tscn")

#endregion


#region fields

var _metadata_list: Array[GameResultMetadata]

@export var _game_results_container: Control

#endregion


#region builtin

func _ready() -> void:

	#TODO: change ascending/descending sort by button
	_metadata_list.sort_custom(func(a, b): return a.timestamp > b.timestamp)

	for index in range(_metadata_list.size()):
		var metadata = _metadata_list[index]
		var metadata_view = GameResultMetadataView.make_with_metadata(index + 1, metadata)
		metadata_view.about_pressed.connect(game_result_metadata_examined.emit.bind(metadata))
		_game_results_container.add_child(metadata_view)

#endregion


#region static

static func make_with_result_metadata_list(result_metadata_list: Array[GameResultMetadata]) -> GameResultsList:
	var new_game_results_list = PRELOADED_SCENE.instantiate()
	new_game_results_list._metadata_list = result_metadata_list
	return new_game_results_list

#endregion
