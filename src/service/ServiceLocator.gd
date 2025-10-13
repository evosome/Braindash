## Service locator singleton
extends Node


#region fields

var _service_map: Dictionary[Script, Object] = {}

#endregion


#region public

func register(type: Script, value: Object) -> void:
	_service_map[type] = value


func get_of(type: Script) -> Object:
	assert(
		_service_map.has(type),
		"Service {service_name} was not registered in the current scope".format({
			service_name = type.get_global_name()
		}))
	return _service_map.get(type)

#endregion
