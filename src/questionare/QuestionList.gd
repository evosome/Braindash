## Resource, that presents a sequence of questions types, not
## questions itselfs.
## [class Questionare] uses it to build the sequence of
## questions.
class_name QuestionList extends Resource


#region fields

@export var questions: Array[QuestionType]

#endregion
