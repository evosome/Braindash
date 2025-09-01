
class_name PlayerInfo extends Object


#region fields

var _nickname: String
# TODO: add acessories and achievements

#endregion


#region builtins

func _to_string() -> String:
	return "<Player#nickname=\"{0}\">".format([_nickname])

#endregion


#region getters/setters

func get_nickname() -> String:
	return _nickname

#endregion
