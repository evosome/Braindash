## Stateless resource, describing question info
class_name QuestionType extends Resource


#region fields

## Question title, giving brief information about the question
@export var title: String

## Question description, giving more helpful information about the question
@export var description: String

## Image, describing math formulas or any visual texts
@export var image: Texture2D

## Answer variants, presented as strings
@export var variants: Array[String]

## Correct answer index, starting from 0
@export var correct_index: int = 0

## Time to answer for the question. When a negative value
## set (for example, [code]-1[/code]), it means that question
## has no time to answer for.
@export var timeout_seconds: float = 30.0

#endregion


#region getters/setters

## Whether the question will have time to answer for it.
func has_timeout() -> bool:
	return timeout_seconds > 0


## Get the correct answer string.
## Shorthand for [code]question_type.variants[question_type.correct_index][/code]
func get_correct() -> String:
	return variants[correct_index]

#endregion
