
class_name QuestionType extends Resource

@export var title: String
@export var description: String
@export var image: Texture2D
@export var variants: Array[String]
@export var correct_index: int = 0
@export var timeout_seconds: float = 30.0


func has_timeout() -> bool:
	return timeout_seconds > 0
