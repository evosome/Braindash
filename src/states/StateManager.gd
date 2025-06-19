class_name StateManager

var _state_map: Dictionary[String, State] = {}
var _current_state: State


#region public

func register(name: String, state: State) -> void:
    _state_map[name] = state


func unregister(name: String) -> void:
    _state_map.erase(name)


@warning_ignore_start("redundant_await")
func transition_to(name: String) -> void:
    if _current_state:
        await _current_state.on_exit()
    
    var new_state = _state_map.get(name)
    if !new_state:
        push_error("Unable to make transition, because state \"{state_name}\" not registered".format({
            state_name = name
        }))
        return
    
    _current_state = new_state
    await _current_state.on_enter()
@warning_ignore_restore("redundant_await")

#endregion
