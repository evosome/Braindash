extends MenuSubscreen


#region fields

@export var _start_button: Button
@export var _quit_button: Button
@export var _game_results_button: Button
@export var _about_game_button: Button

#endregion


#region services

@onready var _popup_manager = ServiceLocator.get_of(AbstractPopupManager) as AbstractPopupManager

#endregion


#region builtin

func _ready() -> void:
	assert(_start_button, "Start button is not set on MenuSubscreen")
	assert(_quit_button, "Quit button is not set on MenuSubscreen")
	assert(_game_results_button, "Game results button is not set on MenuSubscreen")
	assert(_about_game_button, "About game button is not set on MenuSubscreen")
	
	_quit_button.pressed.connect(_on_quit_button_pressed)

#endregion


#region virtuals

func on_enter(ctx: SharedContext) -> void:
	_start_button.pressed.connect(_on_start_button_pressed)
	_game_results_button.pressed.connect(_on_game_results_button_pressed)
	
	_about_game_button.pressed.connect(_on_about_game_button_pressed)

#endregion


#region event handlers

func _on_quit_button_pressed() -> void:
	##TODO: maybe create exit method on ctx?
	get_tree().quit()


func _on_start_button_pressed() -> void:
	switch("characters")


func _on_game_results_button_pressed() -> void:
	switch("game_results")


func _on_about_game_button_pressed() -> void:
	var about_game_popup = AboutGamePopup.make()
	_popup_manager.open_popup(about_game_popup)

#endregion
