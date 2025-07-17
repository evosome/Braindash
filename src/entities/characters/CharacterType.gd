class_name CharacterType extends Resource

@export var kind: String
@export var kind_icon: Texture2D
@export var ability_icons: Array[Texture2D]
@export var name: String
@export var description: String
@export var packed_sprite: PackedScene


func get_attack_type() -> AttackType:
    return
