class_name GameResultsSubscreen extends MenuSubscreen


#region constants

const PRELOADED_SCENE = preload("GameResultsSubscreen.tscn")

#endregion


@export var _back_button: Button
@export var _game_results_container: Control


#region virtuals

func on_enter(ctx: MenuContext) -> void:

	_back_button.pressed.connect(_on_back_button_pressed.bind(ctx))

	var user_data = ctx.get_user_data()
	var game_results = user_data.get_game_results()
	var game_results_indexed = game_results.get_all_indexed()
	var metadata_list = GameResultsList.make_with_result_metadata_list(game_results_indexed)
	metadata_list.game_result_metadata_examined.connect(_on_metadata_examined.bind(ctx))
	_game_results_container.add_child(metadata_list)

#endregion


#region event handlers

func _on_back_button_pressed(ctx: MenuContext) -> void:
	ctx.switch_subscreen("main")


func _on_metadata_examined(metadata: GameResultMetadata, ctx: MenuContext) -> void:
	
	var user_data = ctx.get_user_data()
	var game_results = user_data.get_game_results()
	var game_result = game_results.load(metadata.path)

	var popup_manager = ctx.get_popup_manager()
	var game_result_info = GameResultInfo.make_from_result(game_result)
	popup_manager.open_popup(game_result_info)

#endregion
