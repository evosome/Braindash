## Singleton, used for storing and getting loaded resources
## with their ID paths.
extends Node


#region fields

var _storage: Dictionary[String, Variant] = {}

#endregion


#region public

## Get registered object by its ID
func get_one(identifier: Id) -> Object:
    assert(identifier.is_resource(), "Identifier must refer to single resource, not resource catalog")

    var id_fullpath = identifier.to_string()
    return _storage[id_fullpath]


func get_all(path: String) -> Array:
    var result_array = []

    var maybe_array = _storage[path]
    if maybe_array is Array:
        result_array.assign(maybe_array)

    return result_array


func register(identifier: Id, instance: Object) -> void:
    
    var id_path = identifier.get_path()

    if !_storage.has(id_path):
        _storage[id_path] = []
    
    var categorized_objects = _storage[id_path]
    categorized_objects.append(instance)

    var id_fullpath = identifier.to_string()
    _storage[id_fullpath] = instance

#endregion
