## Context class, shared between all screens and its subscreens.
## Any screen can affect this context. Please read the documentation about
## certain screen to understand, what context fields the screen can affect.
class_name SharedContext

var last_game_result: SingleplayerGameResult
var is_game_over: bool = false

var selected_grade: Grade
var selected_topic: Topic
var selected_character_type: CharacterType
