## Class used for opening popup in the certain container. For
## example, opening popups above the all UI components set in game root.
class_name AbstractPopupManager extends Control


#region abstract

## This method is asynchronous.
## Asynchronously open popup with any animation or else.
@warning_ignore("unused_parameter")
func open_popup(popup: AbstractPopup) -> void: pass

#endregion
