class_name GameResultsSubscreen extends MenuSubscreen


#region constants

const PRELOADED_SCENE = preload("GameResultsSubscreen.tscn")

#endregion


#region fields

@export var _back_button: Button
@export var _game_results_container: Control

#endregion


#region services

@onready var _user_data = ServiceLocator.get_of(UserData) as UserData
@onready var _popup_manager = ServiceLocator.get_of(AbstractPopupManager) as AbstractPopupManager

#endregion


#region virtuals

func on_enter(_ctx: SharedContext) -> void:

	_back_button.pressed.connect(_on_back_button_pressed)

	var game_results = _user_data.get_game_results()
	var game_results_indexed = game_results.get_all_indexed()
	var metadata_list = GameResultsList.make_with_result_metadata_list(game_results_indexed)
	metadata_list.game_result_metadata_examined.connect(_on_metadata_examined)
	_game_results_container.add_child(metadata_list)

#endregion


#region event handlers

func _on_back_button_pressed() -> void:
	switch("main")


func _on_metadata_examined(metadata: GameResultMetadata) -> void:
	
	var game_results = _user_data.get_game_results()
	var game_result = game_results.load(metadata.path)

	var game_result_info = GameResultInfo.make_from_result(game_result)
	_popup_manager.open_popup(game_result_info)

#endregion
