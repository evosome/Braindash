#abstract
class_name AttackType extends Resource

#region abstract

func perform(arena: Arena, attacker: PlayerCharacter, attackable: PlayerCharacter) -> void:
	pass

#endregion
