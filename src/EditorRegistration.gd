## Helper class for simple registration via editor
class_name EditorRegistration extends Node


#region fields

@export var _domain: String = "Braindash"
@export var _groups: Array[EditorRegistrationGroup]

#endregion


#region builtins

func _ready() -> void:
	_install()

#endregion


#region private

func _install() -> void:
	for group in _groups:
		var group_path = group.path
		var entries = group.registry_entries
		for entry in entries:
			# TODO - make abstract registry class and make installation for abstract registry,
			# not concrete (singleton)
			var entry_name = entry.qualified_name
			var entry_instance = entry.instance
			var id = Id.of(_domain, group_path, entry_name)
			Registry.register(id, entry_instance)

			print_debug("Registered new {instance} on id: \"{id}\"".format({
				instance = entry_instance,
				id = id
			}))

#endregion
