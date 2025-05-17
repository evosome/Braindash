
class_name PlayerInfo extends Object

var _nickname: String
# TODO: add acessories and achievements


func get_nickname() -> String:
	return _nickname


func _to_string() -> String:
	return "<Player#nickname=\"{0}\">".format([_nickname])
