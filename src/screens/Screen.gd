class_name Screen extends Control


#region signals

## Fired, when the screen appears
signal entered()

#endregion


#region virtual

func on_enter(ctx) -> void:
	entered.emit()

#endregion
