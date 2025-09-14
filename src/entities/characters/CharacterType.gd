class_name CharacterType extends Resource

@export var kind: String
@export var kind_icon: Texture2D
@export var ability_icons: Array[Texture2D]
@export var name: String
@export var description: String
@export var common_damage: int
@export var packed_sprite: PackedScene

## The game calculates damage using [class]DamageCalculator[/class] set
## in game info. All implementations of damage calculator consider this damage scale,
## that will be multiplied by calculated damage value.
@export var damage_multiplier: float = 1.0


func get_attack_type() -> AttackType:
	return
