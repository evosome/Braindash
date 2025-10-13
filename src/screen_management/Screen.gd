@abstract
class_name Screen extends Control


#region signals

signal entered()

#endregion


#region fields

var _screen_manager_ref: ScreenManager

#endregion


#region abstract

@abstract func on_enter(ctx) -> void

#endregion


#region public

func enter(manager_ref: ScreenManager, ctx) -> void:
	_screen_manager_ref = manager_ref
	on_enter(ctx)
	entered.emit()


func switch(other_name: String) -> void:
	_screen_manager_ref.switch(other_name)

#endregion
