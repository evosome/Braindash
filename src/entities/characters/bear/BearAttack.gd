class_name BearAttack extends AttackType

const RIFT_AMOUNT = 6


func perform(arena: Arena, attacker: PlayerCharacter, attackable: PlayerCharacter) -> void:

	var attacker_position = attacker.position
	var attackable_position = attackable.position

	var camera = arena.get_camera()
	await camera.zoom_in(attacker.position, 1.0)

	await attacker.async_play_animation(CharacterSprite.Animations.ATTACK_PREPARE)

	var direction_sign = sign(attackable.position - attacker.position)
	var distance_between = attacker.position.distance_to(attackable.position)
	var rift_margin = distance_between / RIFT_AMOUNT
	var ground_curve = arena.get_curve_of_ground()

	camera.zoom_in(attackable_position, 1.0, RIFT_AMOUNT * 0.2)

	const RIFT_RATIO_SCALE = 1.0 / RIFT_AMOUNT
	
	attacker.async_play_animation(CharacterSprite.Animations.ATTACK)

	for i in range(1, RIFT_AMOUNT + 1):
		var unprojected_rift_position = attacker_position + rift_margin * direction_sign * i
		var closest_offset = ground_curve.get_closest_offset(unprojected_rift_position)
		var projected_rift_transform = ground_curve.sample_baked_with_rotation(closest_offset)

		var rift = Rift.make()
		rift.set_transform(projected_rift_transform)
		rift.set_hflip(direction_sign.x < 0)
		rift.set_destroy_on_end(true)
		rift.set_scale(Vector2.ONE * RIFT_RATIO_SCALE * i)
		arena.spawn(rift)

		camera.shake(25 * i, 0.2)
		await rift.come_from_ground()

	await attackable.async_play_animation(CharacterSprite.Animations.HURT)
	attackable.damage(attacker.get_damage())

	attackable.async_play_animation(CharacterSprite.Animations.IDLE)
	attacker.async_play_animation(CharacterSprite.Animations.IDLE)

	await camera.zoom_off()
