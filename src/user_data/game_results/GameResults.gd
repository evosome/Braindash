class_name GameResults

#region constants

const DEAFULT_SAVE_FILE_EXT = ".tres"
const DEFAULT_INDEX_FILE_NAME = "game_results.tres"

#endregion


var _path: String
var _index_file_path: String

var _index_cache: GameResultIndexes


#region constructor

func _init(path: String) -> void:

    if !DirAccess.dir_exists_absolute(path):
        DirAccess.make_dir_absolute(path)

    _path = path
    _index_file_path = path.path_join(DEFAULT_INDEX_FILE_NAME)
    _load_index()

#endregion


#region public

func get_all_indexed() -> Array[GameResultMetadata]:
    return _index_cache.get_metadata_list()


func save(result: SingleplayerGame.Result) -> void:
    var unique_index = UUID.v4()
    var game_result_path = _path.path_join(unique_index) + DEAFULT_SAVE_FILE_EXT

    ResourceSaver.save(result, game_result_path)

    _do_index_file(unique_index, game_result_path, result)


func load(path: String) -> SingleplayerGame.Result:
    var loaded_results = ResourceLoader.load(path)
    return loaded_results

#endregion


#region private

func _load_index() -> void:
    if ResourceLoader.exists(_index_file_path):
        var index_cache = ResourceLoader.load(_index_file_path)
        if index_cache is GameResultIndexes:
            _index_cache = index_cache
            return
    _index_cache = GameResultIndexes.new()
    ResourceSaver.save(_index_cache, _index_file_path)


func _do_index_file(file_idx: String, file_path: String, result: SingleplayerGame.Result) -> void:
    var timestamp = result.get_timestamp()
    var result_flag = result.get_result_flag()
    var new_metadata = GameResultMetadata.make(file_idx, file_path, timestamp, result_flag)

    var metadata_list = _index_cache.metadata_list
    metadata_list.append(new_metadata)

    ResourceSaver.save(_index_cache, _index_file_path)

#endregion
