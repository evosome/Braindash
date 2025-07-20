class_name CharacterStats extends Control

const DEFAULT_MIN_HEALTH = 0
const DEFAULT_MAX_HEALTH = 100

var _current_character: PlayerCharacter
var _health_component: HealthComponent

@export var _icon_texture_rect: TextureRect

#TODO: decompose this to health indicator widget
@export var _health_progress_bar: ProgressBar


#region getter/setter

## Set what player character's information should be displayed on. Null character can be
## set, so character stats will be disabled.
func set_character(player_character: PlayerCharacter) -> void:
	_current_character = player_character
	if player_character != null:
		_update(player_character)
	else:
		_disable()


func get_character() -> PlayerCharacter:
	return _current_character

#endregion


#region private

func _disable() -> void:
	_icon_texture_rect.texture = null #TODO: set placeholder image instead of null
	_health_progress_bar.value = DEFAULT_MIN_HEALTH
	_health_progress_bar.max_value = DEFAULT_MAX_HEALTH

	_health_component.health_changed.disconnect(_on_health_changed)


func _update(player_character: PlayerCharacter) -> void:
	var character_type = player_character.get_type()
	_update_icon_texture(character_type.kind_icon)

	var health_component = player_character.get_health()
	_configure_health_component(health_component)


func _update_icon_texture(character_icon: Texture2D) -> void:
	_icon_texture_rect.texture = character_icon


func _configure_health_component(health_component: HealthComponent) -> void:
	_health_component = health_component

	var max_health = health_component.get_max_health()
	_health_progress_bar.max_value = max_health

	var current_health = health_component.get_health()
	_health_progress_bar.value = current_health

	health_component.health_changed.connect(_on_health_changed)

#endregion


#region event handlers

func _on_health_changed(new_health_value: int) -> void:
	_health_progress_bar.value = new_health_value

#endregion
