@abstract
class_name BuffType extends Resource


#region fields

@export var _icon: Texture2D
@export var _amplifier: float = 1.0

#endregion


#region setters/getters

func get_icon() -> Texture2D:
    return _icon


func get_amplifier() -> float:
    return _amplifier

#endregion


#region abstract

@abstract func affect(character: PlayerCharacter) -> void
@abstract func should_dispel(character: PlayerCharacter) -> bool

#endregion
