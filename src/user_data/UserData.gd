class_name UserData


#region constants

const GAME_RESULTS_PATH = "game_results"

#endregion

var _game_results: GameResults


#region constructor

func _init(location: String = "user://") -> void:
    var game_results_path = location.path_join(GAME_RESULTS_PATH)

    _game_results = GameResults.new(game_results_path)

#endregion


#region public

func get_game_results() -> GameResults:
    return _game_results

#endregion
