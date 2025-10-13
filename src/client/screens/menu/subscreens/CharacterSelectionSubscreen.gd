extends MenuSubscreen

const CHARACTER_ICON_PACKED = preload("res://src/ui/character/CharacterIcon.tscn")


#region fields

var _current_character_type: CharacterType

@onready var _back_button: Button = %"BackButton"
@onready var _continue_button: Button = %"ContinueButton"
@onready var _character_name_label: Label = %"CharacterNameLabel"
@onready var _character_kind_label: Label = %"CharacterKindNameLabel"
@onready var _character_description_label: Label = %"CharacterDescriptionName"
@onready var _character_icons_grid: GridContainer = %"CharacterIconsGrid"

@onready var _available_character_types = Registry.get_all("resources.characterTypes.playables")

#endregion


#region built-in

func _ready() -> void:
	_continue_button.set_disabled(true)

#endregion


#region virtuals

func on_enter(ctx: SharedContext) -> void:
	_back_button.pressed.connect(_on_back_button_pressed.bind(ctx))
	_continue_button.pressed.connect(_on_continue_button_pressed.bind(ctx))

	_show_available_characters(_available_character_types)

#endregion


#region private

func _show_available_characters(chars: Array) -> void:
	for char in chars:
		var character_icon = CHARACTER_ICON_PACKED.instantiate()
		_character_icons_grid.add_child(character_icon)
		character_icon.set_icon_texture(char.kind_icon)
		character_icon.clicked.connect(_on_character_icon_pressed.bind(char))


func _set_current_character_type(character_type: CharacterType) -> void:
	_current_character_type = character_type
	_character_name_label.text = character_type.name
	_character_kind_label.text = character_type.kind
	_character_description_label.text = character_type.description

#endregion


#region event handlers

func _on_character_icon_pressed(with_type: CharacterType) -> void:
	_set_current_character_type(with_type)
	_continue_button.set_disabled(false)


func _on_back_button_pressed(ctx: SharedContext) -> void:
	switch("main")


func _on_continue_button_pressed(ctx: SharedContext) -> void:
	ctx.selected_character_type = _current_character_type
	switch("grades")

#endregion
