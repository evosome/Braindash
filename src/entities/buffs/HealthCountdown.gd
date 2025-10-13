class_name HealthCountdown extends BuffType


#region overrides

func affect(character: PlayerCharacter) -> void:
	var health_component = character.get_health()

	var calculated_damage = get_amplifier()
	health_component.set_health(health_component.get_health() - calculated_damage)


func should_dispel(character: PlayerCharacter) -> bool:
	var health_component = character.get_health()
	if health_component.is_dead():
		return true
	
	return false

#endregion
