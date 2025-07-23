class_name RoundCount extends Control


#region constants

const PRELOADED_SCENE = preload("RoundCount.tscn")
const ROUND_COUNTER_TEXT = "Раунд {0}"

#endregion


@export var _round_counter_label: Label


#region getter/setter

func set_round_count(value: int) -> void:
	_round_counter_label.text = ROUND_COUNTER_TEXT.format([value])

#endregion


#region static

static func make_with_count(round_count: int) -> RoundCount:
	var preloaded_round_count = PRELOADED_SCENE.instantiate()
	preloaded_round_count.set_round_count(round_count)
	return preloaded_round_count

#endregion
