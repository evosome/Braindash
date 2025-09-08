class_name EyeAttack extends AttackType


func perform(arena: Arena, attacker: PlayerCharacter, attackable: PlayerCharacter) -> void:

	var attacker_position = attacker.position
	var attackable_position = attackable.position

	var camera = arena.get_camera()
	await camera.zoom_in(attacker_position, 1.0)

	await attacker.async_play_animation(CharacterSprite.Animations.ATTACK_PREPARE)

	var attacker_eyes_line = attacker_position
	var attacker_sprite = attacker.get_sprite()
	if attacker_sprite.has_line_of_eyes():
		attacker_eyes_line = attacker_sprite.get_line_of_eyes()
	else:
		push_warning("Line of eyes of attacker is not set on its sprite... Beam will be flashed from attacker's body")

	var desintegration_beam = DesintegrationBeam.make()
	desintegration_beam.set_start_point(attacker_eyes_line)
	desintegration_beam.set_end_point(attackable_position)
	desintegration_beam.flash()
	arena.spawn(desintegration_beam)

	camera.shake(100.0, 1.2)
	camera.zoom_in(attackable_position, 1.0)

	await attacker.async_play_animation(CharacterSprite.Animations.ATTACK)

	await attackable.async_play_animation(CharacterSprite.Animations.HURT)
	attackable.damage(attacker.get_damage())

	attackable.async_play_animation(CharacterSprite.Animations.IDLE)
	attacker.async_play_animation(CharacterSprite.Animations.IDLE)

	await camera.zoom_off()
