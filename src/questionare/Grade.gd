class_name Grade extends Resource


#region fields

@export var name: String
@export var topics: Array[Topic]

## @deprecated: Authro name is now set on [Topic] info
@export var author_name: String

#endregion
