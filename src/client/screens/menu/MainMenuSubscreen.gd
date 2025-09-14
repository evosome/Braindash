extends MenuSubscreen

@export var _start_button: Button
@export var _quit_button: Button
@export var _game_results_button: Button
@export var _about_game_button: Button


#region builtin

func _ready() -> void:
	assert(_start_button, "Start button is not set on MenuSubscreen")
	assert(_quit_button, "Quit button is not set on MenuSubscreen")
	assert(_game_results_button, "Game results button is not set on MenuSubscreen")
	assert(_about_game_button, "About game button is not set on MenuSubscreen")
	
	_quit_button.pressed.connect(_on_quit_button_pressed)

#endregion


#region virtuals

func on_enter(ctx: MenuContext) -> void:
	_start_button.pressed.connect(_on_start_button_pressed.bind(ctx))
	_game_results_button.pressed.connect(_on_game_results_button_pressed.bind(ctx))
	
	var popup_manager = ctx.get_popup_manager()
	_about_game_button.pressed.connect(_on_about_game_button_pressed.bind(popup_manager))

#endregion


#region event handlers

func _on_quit_button_pressed() -> void:
	##TODO: maybe create exit method on ctx?
	get_tree().quit()


func _on_start_button_pressed(ctx: MenuContext) -> void:
	ctx.switch_subscreen("characters")


func _on_game_results_button_pressed(ctx: MenuContext) -> void:
	ctx.switch_subscreen("game_results")


func _on_about_game_button_pressed(popup_manager: AbstractPopupManager) -> void:
	var about_game_popup = AboutGamePopup.make()
	popup_manager.open_popup(about_game_popup)

#endregion
