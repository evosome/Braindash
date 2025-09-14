
class_name Screen extends Control

signal entered()

func on_enter(ctx) -> void:
	entered.emit()
