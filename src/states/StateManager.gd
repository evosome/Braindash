class_name StateManager

signal ended

var _state_map: Dictionary[String, State] = {}
var _current_state: State
var _context: Variant


#region public


func set_context(ctx: Variant) -> void:
    _context = ctx


func register(id: Variant, state: State) -> void:
    _state_map[id] = state


func unregister(id: Variant) -> void:
    _state_map.erase(id)


@warning_ignore_start("redundant_await")
func transition_to(id: Variant) -> void:
    if _current_state:
        await _current_state.on_exit(_context)
    
    var new_state = _state_map.get(id)
    if !new_state:
        push_error("Unable to make transition, because state \"{state_name}\" is not registered".format({
            state_name = id
        }))
        return
    
    _current_state = new_state
    await _current_state.on_enter(_context)
@warning_ignore_restore("redundant_await")


func end() -> void:
    _current_state = null
    ended.emit()

#endregion
