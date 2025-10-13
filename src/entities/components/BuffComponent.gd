class_name BuffComponent extends Node


#region fields

var _buffs: Array[BuffType] = []

@export var _timer: Timer
@export var _target: PlayerCharacter

#endregion


#region builtins

func _ready() -> void:
	assert(_timer, "Timer is not set on BuffComponent")
	_timer.timeout.connect(_on_tick)

#endregion


#region public

func add(buff_type: BuffType) -> void:
	_buffs.append(buff_type)

#endregion


#region private

func _remove(buff: BuffType) -> void:
	_buffs.erase(buff)

#endregion


#region event handlers

func _on_tick() -> void:
	for buff in _buffs:
		if buff.should_dispel(_target):
			_remove(buff)
		else:
			buff.affect(_target)

#endregion
