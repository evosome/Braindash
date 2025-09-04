class_name GameResultMetadataView extends Control

## Emit when about button was pressed
signal about_pressed()


#region constants

const PRELOADED_SCENE = preload("GameResultMetadataView.tscn")

#endregion


var _game_result_metadata: GameResultMetadata

@export var _about_button: Button
@export var _result_badge: GameResultBadge
@export var _game_count_label: Label
@export var _game_date_label: Label
@export var _game_id_label: Label


#region builtin

func _ready() -> void:
	_about_button.pressed.connect(about_pressed.emit)

#endregion


#region public

func set_result_flag(value: SingleplayerGame.ResultFlag) -> void:
	var popup = GameResultBadge.game_result_to_badge(value)
	_result_badge.set_badge(popup)


func set_count(value: int) -> void:
	_game_count_label.text = String.num(value, 0)


func set_date_timestamp(value: float) -> void:
	var time_dict = Time.get_datetime_dict_from_unix_time(value)

	var formatted_date = "%02d.%02d.%02d" % [
		time_dict.get("day"),
		time_dict.get("month"),
		time_dict.get("year")
	]

	_game_date_label.text = formatted_date


func set_id(value: String) -> void:
	_game_id_label.text = value

#endregion


#region static

static func make_with_metadata(index: int, game_result_metadata: GameResultMetadata) -> GameResultMetadataView:
	var game_result_metadata_view = PRELOADED_SCENE.instantiate()
	game_result_metadata_view._game_result_metadata = game_result_metadata
	game_result_metadata_view.set_count(index)
	game_result_metadata_view.set_result_flag(game_result_metadata.result_flag)
	game_result_metadata_view.set_date_timestamp(game_result_metadata.timestamp)
	game_result_metadata_view.set_id(game_result_metadata.idx)
	return game_result_metadata_view

#endregion
