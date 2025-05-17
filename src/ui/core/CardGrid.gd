class_name CardGrid extends Control

signal card_selected(card: SelectionCard)

@onready var _title_label: Label = %"CardGridTitle"
@onready var _cards_container: Control = %"CardContainer"

#region public

func set_title(value: String) -> void:
	_title_label.text = value


func add_card(card: SelectionCard) -> void:
	card.selected.connect(_on_card_selected.bind(card))
	_cards_container.add_child(card)


func remove_card(card: SelectionCard) -> void:
	card.selected.disconnect(_on_card_selected)
	_cards_container.remove_child(card)

#endregion


#region event handlers

func _on_card_selected(card: SelectionCard) -> void:
	card_selected.emit(card)

#endregion
