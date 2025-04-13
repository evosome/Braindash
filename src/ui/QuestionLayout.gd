class_name QuestionLayout extends Control

@export var _question_timer: QuestionTimer
@export var _question_title_label: Label
@export var _question_texture_rect: TextureRect


func _ready() -> void:
	assert(_question_title_label != null, "Title label of the question layout not set")
	assert(_question_texture_rect != null, "Texture rectangle of the question layout not set")


func set_question_title(question_title: String) -> void:
	_question_title_label.text = question_title


func set_image_enabled(enabled: bool) -> void:
	_question_texture_rect.visible = enabled


func set_question_image_texture(texture: Texture2D) -> void:
	_question_texture_rect.texture = texture


func set_question_timer_enabled(enabled: bool) -> void:
	_question_timer.visible = enabled


func start_question_timer(secs: float) -> void:
	_question_timer.start_timer(secs)


func reset_question_timer() -> void:
	_question_timer.reset_timer()
