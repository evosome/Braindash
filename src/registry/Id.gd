class_name Id extends RefCounted


#region fields

var _domain: String
var _path: String
var _resource: String
var _is_resource: bool

#endregion


#region builtins

func _init(domain: String, path: String, resource: Variant = null) -> void:
    _domain = domain
    _path = path
    _resource = resource if resource != null else ""
    _is_resource = _resource != null


func _to_string() -> String:
    return "%s:%s.%s" % [_domain, _path, _resource]

#endregion


#region setters/getters

func get_path() -> String:
    return _path


func is_catalog() -> bool:
    return !_is_resource


func is_resource() -> bool:
    return _is_resource

#endregion


#region static

## Create new ID object, describing the registered in Registry object.
## [resource param] can be null, so ID will refer to catalog of resources, not the resource.
static func of(domain: String, path: String, resource: Variant = null) -> Id:
    return Id.new(domain, path, resource)


static func of_game(path: String, resource: Variant = null) -> Id:
    return Id.new("Braindash", path, resource)

#endregion
