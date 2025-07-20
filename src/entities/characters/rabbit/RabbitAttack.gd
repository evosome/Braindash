class_name RabbitAttack extends AttackType


func perform(arena: Arena, attacker: PlayerCharacter, attackable: PlayerCharacter) -> void:

	#TODO - attack type should not control animations of characters and camera. Make states for characters

	var camera = arena.get_camera()
	await camera.zoom_in(attacker.position, 2)

	await attacker.async_play_animation(CharacterSprite.Animations.ATTACK)

	var arrow = ArrowProjectile.make(attacker.position, attackable.position, 1.0)
	camera.set_following_target(arrow)
	arena.spawn(arrow)
	await arrow.fly()

	camera.set_following_target(null)

	await attackable.async_play_animation(CharacterSprite.Animations.HURT)
	attackable.damage(attacker.get_damage())

	attackable.async_play_animation(CharacterSprite.Animations.IDLE)
	attacker.async_play_animation(CharacterSprite.Animations.IDLE)

	await camera.zoom_off()
