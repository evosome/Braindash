class_name TopicSelectionSubscreen extends MenuSubscreen


#region constants

#TODO - move these constant to their classes and create `make` static function
const SELECTION_CARD_PACKED = preload("res://src/ui/core/SelectionCard.tscn")
const CHARACTER_ICON_PACKED = preload("res://src/ui/character/CharacterIcon.tscn")

#endregion


#region fields

@onready var _back_button: Button = %"BackButton"
@onready var _continue_button: Button = %"ContunueButton"
@onready var _cards_grid: CardGrid = %"CardGrid"

#endregion


#region built-in

func _ready() -> void:
	_cards_grid.set_title("Выбор темы")
	_continue_button.set_disabled(true)

#endregion


#region virtuals

func on_enter(ctx: SharedContext) -> void:
	
	_back_button.pressed.connect(_on_back_button_pressed)
	_continue_button.pressed.connect(_on_continue_button_pressed)
	_cards_grid.card_selected.connect(func(card): _on_card_selected(ctx, card))
	
	var current_grade = ctx.selected_grade
	if !current_grade:
		push_error("Entered topic selection screen, but current grade is not set")
		return

	_show_grade_cards(current_grade.topics, current_grade.accent_color)

#endregion


#region private

func _show_grade_cards(topics: Array[Topic], grade_accent: Color) -> void:
	for topic in topics:

		#TODO - inherit card scenes (and maybe types) for grade and topic cards
		var card = SELECTION_CARD_PACKED.instantiate()
		card.set_title(topic.name)
		card.set_header_texture(topic.cover_image)
		card.set_accent_color(grade_accent)
		card.set_context(topic)

		var enemy_character_type = topic.enemy_character_type

		var character_icon = CHARACTER_ICON_PACKED.instantiate()
		character_icon.set_icon_texture(enemy_character_type.kind_icon)
		character_icon.custom_minimum_size = Vector2(64, 64)
		var header = card.get_header()
		header.add_child(character_icon)

		_cards_grid.add_card(card)

#endregion


#region event handlers

func _on_back_button_pressed() -> void:
	switch("grades")


func _on_continue_button_pressed() -> void:
	switch_global("round")


func _on_card_selected(
		ctx: SharedContext,
		card: SelectionCard) -> void:
	_continue_button.set_disabled(false)
	
	var selected_topic = card.get_context() as Topic
	ctx.selected_topic = selected_topic

#endregion
