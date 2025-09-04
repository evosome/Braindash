## Custom abstract popup
class_name AbstractPopup extends Control


#region signals

signal opened()
signal closed()

#endregion


#region fields

var _current_parent: Control

#endregion


#region builtin

func _input(event: InputEvent) -> void:
	if !is_open():
		return

	#TODO: add close on `esc` button pressed
	var need_close = _is_clicked_outside(event)
	if need_close:
		close()

#endregion


#region protected abstract

@warning_ignore("unused_parameter")
func on_open(on: Control) -> void:
	pass


func on_close() -> void:
	pass

#endregion


#region private

# Used to determine if mouse clicked outside the popup
func _is_clicked_outside(event: InputEvent) -> bool:
	if not event is InputEventMouseButton:
		return false
	
	var mouse_event = event as InputEventMouseButton

	var clicked_outside = (
		mouse_event.pressed and
		mouse_event.button_index == MOUSE_BUTTON_LEFT and
		!get_global_rect().has_point(event.position))
	
	return clicked_outside

#endregion


#region public

func is_open() -> bool:
	return _current_parent != null

@warning_ignore_start("redundant_await")

## This method is asynchronous.
## Asynchronously open the popup and emit [signal opened] signal.
func open(on: Control) -> void:

	if _current_parent:
		push_error("Popup is already opened on node: {parent}".format({
			parent = _current_parent
		}))
		return

	on.add_child(self)
	_current_parent = on

	await on_open(on)
	opened.emit()


## This method is asynchronous.
## Asynchronously close the popup and emit [signal closed] signal.
func close() -> void:

	if !_current_parent:
		push_error("Popup is not opened")
		return

	_current_parent.remove_child(self)
	await on_close()
	closed.emit()

@warning_ignore_restore("redundant_await")

#endregion
