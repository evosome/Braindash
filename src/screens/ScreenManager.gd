class_name ScreenManager


#region fields

var _screen: Screen
var _screen_ctx
var _managing_node: Node

var _registration_map: Dictionary[String, PackedScene] = {}

#endregion


#region builtins

func _init(on: Node) -> void:
	_managing_node = on

#endregion


#region getters/setters

## Set screen context, that will be shared between screens registered
## in this screen manager.
func set_context(ctx) -> void:
	_screen_ctx = ctx

#endregion


#region public

## Replace current screen with other by its name. To switch between
## screens, it must be registered first with [member register].
func switch(name: String) -> void:
	
	var packed_screen: PackedScene = _registration_map.get(name, null)
	
	if !packed_screen:
		push_error("Screen name not found in registered map: " + name)
		return
	
	if _screen:
		_managing_node.remove_child(_screen)

	var initialized_screen = packed_screen.instantiate()
	_managing_node.add_child(initialized_screen)
	_screen = initialized_screen
	_screen.on_enter(_screen_ctx)


## Register packed scene of screen, using its name as identifier.
func register(name: String, packed: PackedScene) -> void:
	_registration_map[name] = packed

#endregion


#region static

static func on(node: Node) -> ScreenManager:
	return ScreenManager.new(node) 

#endregion
