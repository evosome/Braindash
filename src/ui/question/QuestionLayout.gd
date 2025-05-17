class_name QuestionLayout extends Control

signal answered(text: String)

var _disabled: bool = false

@export var _question_timer: QuestionTimer
@export var _question_title_label: Label
@export var _question_texture_rect: TextureRect

@onready var _buttons_grid: Control = %"ButtonGrid"

#region built-in

func _ready() -> void:
	assert(_question_title_label != null, "Title label of the question layout not set")
	assert(_question_texture_rect != null, "Texture rectangle of the question layout not set")
	
	_bind_answer_buttons()

#endregion

#region public

## Set question type to render
func set_question_type(question_type: QuestionType) -> void:
	_set_question_title(question_type.title)
	
	var question_image = question_type.image
	_set_image_enabled(question_image != null)
	if question_image:
		_set_question_image_texture(question_image)
	
	var question_timeout = question_type.timeout_seconds
	if question_timeout > 0:
		_set_question_timer_seconds(question_timeout)
	
	_build_answer_buttons(question_type.variants)


## Make question timer to countdown
func start_question_timer() -> void:
	_question_timer.start()


func reset_question_timer() -> void:
	_question_timer.reset()


func set_disabled(value: bool) -> void:
	_disabled = value
	_set_buttons_disabled(value)

#endregion

#region private

func _set_question_title(question_title: String) -> void:
	_question_title_label.text = question_title


func _set_question_image_texture(texture: Texture2D) -> void:
	_question_texture_rect.texture = texture


func _set_image_enabled(enabled: bool) -> void:
	_question_texture_rect.visible = enabled


func _set_question_timer_enabled(enabled: bool) -> void:
	_question_timer.visible = enabled


func _set_question_timer_seconds(secs: float) -> void:
	_question_timer.set_seconds(secs)


func _reset_question_timer() -> void:
	_question_timer.reset()


func _get_answer_buttons() -> Array:
	return (_buttons_grid
		.get_children()
		.filter(func(n: Node): return n is AnswerButton)) as Array[AnswerButton]


func _bind_answer_buttons() -> void:
	var buttons = _get_answer_buttons()
	for button in buttons:
		button.pressed.connect(_on_answer_button_pressed.bind(button))


func _build_answer_buttons(answer_variants: Array[String]) -> void:
	var buttons = _get_answer_buttons()
	
	var buttons_size = buttons.size()
	var answers_size = answer_variants.size()
	
	if answers_size > buttons_size:
		push_error(
			"Answer variants (",
			answer_variants,
			") is more than the amount of buttons: ",
			buttons_size)
	
	for i in range(0, buttons_size):
		var button = buttons[i]
		var answer = answer_variants[i]
		button.set_answer_text(answer)


func _set_buttons_disabled(value: bool) -> void:
	var buttons = _get_answer_buttons() as Array[AnswerButton]
	for button in buttons:
		button.disabled = value

#endregion


#region event handlers

func _on_answer_button_pressed(answer_button: AnswerButton) -> void:
	var answer_text = answer_button.get_answer_text()
	print_debug("Answer button pressed with variant: ", answer_text)
	answered.emit(answer_text)

#endregion
