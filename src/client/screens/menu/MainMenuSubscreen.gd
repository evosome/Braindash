extends MenuSubscreen

@export var _start_button: Button
@export var _quit_button: Button


func _ready() -> void:
	assert(_start_button, "Start button is not set")
	assert(_quit_button, "Quit button is not set")
	
	_quit_button.pressed.connect(_on_quit_button_pressed)


func on_enter(ctx: MenuScreen) -> void:
	pass


func _on_quit_button_pressed() -> void:
	get_tree().quit()
