class_name GameResultIndexes extends Resource

@export var metadata_list: Array[GameResultMetadata]


#region static

static func make_from_metadata_list(metadata_list: Array[GameResultMetadata]) -> GameResultIndexes:
    var indexes = GameResultIndexes.new()
    indexes.metadata_list = metadata_list
    return indexes

#endregion