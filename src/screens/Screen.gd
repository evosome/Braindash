
class_name Screen extends Node

signal entered()

func on_enter(ctx) -> void:
	entered.emit()
