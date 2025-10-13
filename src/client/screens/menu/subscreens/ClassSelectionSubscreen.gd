class_name ClassSelectionSubscreen extends Screen

const SELECTION_CARD_PACKED = preload("res://src/ui/core/SelectionCard.tscn")


#region fields

@onready var _back_button: Button = %"BackButton"
@onready var _cards_grid: CardGrid = %"CardGrid"

@onready var _available_grades = Registry.get_all("resources.grades")

#endregion


#region built-in

func _ready() -> void:
	_cards_grid.set_title("Выбор класса")

#endregion


#region virtuals

func on_enter(ctx: SharedContext) -> void:
	_back_button.pressed.connect(_on_back_button_pressed)
	_cards_grid.card_selected.connect(func(card):
		_on_card_selected(ctx, card))
	
	_show_grade_cards(_available_grades)

#endregion


#region private

func _show_grade_cards(grades) -> void:
	for grade in grades:
		var card = SELECTION_CARD_PACKED.instantiate()
		card.set_title(grade.name)
		card.set_accent_color(grade.accent_color)
		card.set_context(grade)
		_cards_grid.add_card(card)

#endregion


#region event handlers

func _on_back_button_pressed() -> void:
	switch("main")


func _on_card_selected(
		ctx: SharedContext,
		card: SelectionCard) -> void:

	ctx.selected_grade = card.get_context() as Grade
	switch("topics")

#endregion
