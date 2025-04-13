class_name QuestionTimer extends Control

var _seconds_remain: int = 0

@onready var _real_timer: Timer = %"RealTimer"
@onready var _timer_progress_bar: ProgressBar = %"TimerProgressBar"


func _ready() -> void:
	assert(_real_timer != null, "Timer (RealTimer) is not set")
	assert(_timer_progress_bar != null, "Progress bar (TimerProgressBar) is not set")
	
	_real_timer.timeout.connect(_on_real_timer_timeout_each_sec)


func start_timer(secs: float) -> void:
	if is_running():
		push_error("Unable to start timer, as it is already running")
		return
	
	_seconds_remain = secs
	
	_set_progress_bar_max_value(secs)
	_set_progress_bar_on_max()
	
	# make the timer count pulses each second
	_real_timer.autostart = true
	_real_timer.start(1)


func reset_timer() -> void:
	if !is_running():
		push_error("Unable to reset timer, as it is not running")
		return
	
	_seconds_remain = 0
	
	_reset_timer_progress_bar()
	
	_real_timer.autostart = false
	_real_timer.stop()


func is_running() -> bool:
	return !_real_timer.is_stopped()


func _set_progress_bar_on_max() -> void:
	_timer_progress_bar.value = _timer_progress_bar.max_value


func _set_progress_bar_max_value(value: float) -> void:
	_timer_progress_bar.max_value = value


func _reset_timer_progress_bar() -> void:
	_timer_progress_bar.value = _timer_progress_bar.min_value


func _tween_progress_bar_countdown(to_secs: float) -> void:
	var countdown_tween = get_tree().create_tween()
	countdown_tween.tween_property(_timer_progress_bar, "value", to_secs, 1.0)


func _on_real_timer_timeout_each_sec() -> void:
	_seconds_remain -= 1
	if _seconds_remain < 0:
		reset_timer()
		return
	_tween_progress_bar_countdown(_seconds_remain)
