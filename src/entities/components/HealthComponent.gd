class_name HealthComponent extends Node

signal died()
signal health_changed(value: int)

var _health_amount: int
var _max_health: int

@export var _initial_max_health: int = 100


#region built-in

func _ready() -> void:
	_max_health = _initial_max_health
	_health_amount = _max_health

#endregion


#region getter/setter

func get_health() -> int:
	return _health_amount


func set_health(value: int) -> void:
	if value > _max_health:
		push_warning("Max health is: ", _max_health, ", but tried to set higher value: ", value)
	if value < 0:
		push_warning("Health cannot be negative value!")
	_health_amount = clamp(value, 0, _max_health)
	health_changed.emit(value)
	
	if _health_amount == 0:
		died.emit()


func get_max_health() -> int:
	return _max_health

#endregion
