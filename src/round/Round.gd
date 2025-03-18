
class_name Round extends Object

var _info: RoundInfo
var _arena: RoundArena


func _init(round_info: RoundInfo) -> void:
	_info = round_info
	_instantiate_arena_from(round_info)


func _instantiate_arena_from(round_info: RoundInfo) -> void:
	var packed_arena = round_info.packed_arena
	if !packed_arena:
		return
	_arena = packed_arena.instantiate()


func is_arena_available() -> bool:
	return _arena != null


func get_info() -> RoundInfo:
	return _info


func get_arena() -> RoundArena:
	return _arena
