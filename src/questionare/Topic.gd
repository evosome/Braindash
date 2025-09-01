## Represents education module
class_name Topic extends Resource


#region fields

@export var name: String

## Optional cover image, that visually describes the educational
## module.
@export var cover_image: Texture2D

## Information about the upcoming battle, see [RoundInfo] for more information
@export var round_info: RoundInfo

## Character's type, that describes which character will spawn on arena
## for battle.
@export var enemy_character_type: CharacterType

## Author name of education module
@export var author_name: String

#endregion
