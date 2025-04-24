class_name TopicSelectionSubscreen extends Screen

const SELECTION_CARD_PACKED = preload("res://src/ui/core/SelectionCard.tscn")

@onready var _back_button: Button = %"BackButton"
@onready var _continue_button: Button = %"ContunueButton"
@onready var _cards_grid: CardGrid = %"CardGrid"

#region built-in

func _ready() -> void:
	_cards_grid.set_title("Выбор темы")
	_continue_button.set_disabled(true)

#endregion


#region virtuals

func on_enter(ctx: MenuScreen) -> void:
	var global_ctx = ctx.get_global_context()
	
	_back_button.pressed.connect(_on_back_button_pressed.bind(ctx))
	_continue_button.pressed.connect(_on_continue_button_pressed.bind(ctx))
	_cards_grid.card_selected.connect(func(card):
		_on_card_selected(ctx, global_ctx, card))
	
	var current_grade = global_ctx.get_current_grade()
	if !current_grade:
		push_error("Entered topic selection screen, but current grade is not set")
		return

	_show_grade_cards(current_grade.topics)

#endregion


#region private

func _show_grade_cards(topics: Array[Topic]) -> void:
	for topic in topics:
		var card = SELECTION_CARD_PACKED.instantiate()
		card.set_title(topic.name)
		card.set_accent_color(Color.DEEP_SKY_BLUE)
		card.set_context(topic)
		_cards_grid.add_card(card)

#endregion


#region event handlers

func _on_back_button_pressed(ctx: MenuScreen) -> void:
	ctx.get_subscreen_manager().switch("grades")


func _on_continue_button_pressed(ctx: MenuScreen) -> void:
	ctx.get_global_context().switch_screen("round")


func _on_card_selected(
		ctx: MenuScreen,
		global_ctx: GameContext,
		card: SelectionCard) -> void:
	_continue_button.set_disabled(false)
	
	var selected_topic = card.get_context() as Topic
	global_ctx.set_current_round_info(selected_topic.round_info)

#endregion
