
class_name ScreenManager extends Object

var _screen: Screen
var _screen_ctx
var _managing_node: Node

var _registration_map: Dictionary[String, PackedScene] = {}

func _init(on: Node) -> void:
	_managing_node = on


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


func register(name: String, packed: PackedScene) -> void:
	_registration_map[name] = packed


func set_context(ctx) -> void:
	_screen_ctx = ctx


static func on(node: Node) -> ScreenManager:
	return ScreenManager.new(node) 
