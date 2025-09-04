class_name GameResultMetadata extends Resource

@export var idx: String
@export var path: String
@export var timestamp: float
@export var result_flag: SingleplayerGame.ResultFlag


#region static

@warning_ignore("shadowed_variable")
static func make(idx: String, path: String, timestamp: float, result_flag: SingleplayerGame.ResultFlag) -> GameResultMetadata:
    var metadata = GameResultMetadata.new()
    metadata.idx = idx
    metadata.path = path
    metadata.timestamp = timestamp
    metadata.result_flag = result_flag
    return metadata

#endregion
