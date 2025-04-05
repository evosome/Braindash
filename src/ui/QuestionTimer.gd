class_name QuestionTimer extends Control

var _tween: Tween

@export var _timer_progress_bar: ProgressBar


func _ready() -> void:
	assert(_timer_progress_bar != null, "Progress bar of the question timer is not set")


func start_timer(secs: int) -> void:
	if _tween != null:
		push_error("Unable to start timer, as it is already running")
		return

	_tween = get_tree().create_tween()
	_tween.tween_property(_timer_progress_bar, "value", _timer_progress_bar.max_value, secs)
	_tween.play()


func reset_timer() -> void:
	if _tween == null:
		push_error("Unable to reset timer, as it is not running")
		return

	_tween.kill()
	_tween = null
	_timer_progress_bar.value = _timer_progress_bar.min_value
