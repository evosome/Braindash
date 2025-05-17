class_name QuestionTimer extends Control

var _seconds_remain: int = 0
var _countdown_tween: Tween

@onready var _real_timer: Timer = %"RealTimer"
@onready var _timer_progress_bar: ProgressBar = %"TimerProgressBar"

#region built-in

func _ready() -> void:
	assert(_real_timer != null, "Timer (RealTimer) is not set")
	assert(_timer_progress_bar != null, "Progress bar (TimerProgressBar) is not set")
	
	_real_timer.timeout.connect(_on_real_timer_timeout_each_sec)

#endregion


#region public

func set_seconds(secs: float) -> void:
	_seconds_remain = secs


func start() -> void:
	
	if _seconds_remain == 0:
		push_error("Unable to start timer, as seconds value is not set")
		return
	
	if is_running():
		push_error("Unable to start timer, as it is already running")
		return
	
	_set_progress_bar_max_value(_seconds_remain)
	_set_progress_bar_on_max()
	
	# make the timer count pulses each second
	_real_timer.autostart = true
	_real_timer.start(1)


func reset() -> void:
	if !is_running():
		push_error("Unable to reset timer, as it is not running")
		return
	
	_seconds_remain = 0
	
	if _countdown_tween:
		_countdown_tween.kill()
	
	_reset_timer_progress_bar()
	
	_real_timer.autostart = false
	_real_timer.stop()


func is_running() -> bool:
	return !_real_timer.is_stopped()

#endregion


#region private

func _set_progress_bar_on_max() -> void:
	_timer_progress_bar.value = _timer_progress_bar.max_value


func _set_progress_bar_max_value(value: float) -> void:
	_timer_progress_bar.max_value = value


func _reset_timer_progress_bar() -> void:
	_timer_progress_bar.value = _timer_progress_bar.min_value


func _tween_progress_bar_countdown(to_secs: float) -> void:
	_countdown_tween = get_tree().create_tween()
	_countdown_tween.tween_property(_timer_progress_bar, "value", to_secs, 1.0)


func _on_real_timer_timeout_each_sec() -> void:
	_seconds_remain -= 1
	if _seconds_remain < 0:
		reset()
		return
	_tween_progress_bar_countdown(_seconds_remain)

#endregion
