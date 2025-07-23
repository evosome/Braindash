class_name GameResultInfo extends Control

enum ResultFlagTextures {
	WIN,
	LOSE,
	DRAW
}

const PRELOADED_SCENE = preload("GameResultInfo.tscn")

@export var _result_flag_texture_rect: TextureRect
@export var _total_question_amount_label: Label
@export var _incorrect_answers_amount_label: Label
@export var _total_question_amount_label_of_incorrect: Label
@export var _result_flag_texture_map: Dictionary[ResultFlagTextures, Texture2D]


#region public

func set_total_question_amount(value: int) -> void:
	var string_amount = String.num(value, 0)
	_total_question_amount_label.text = string_amount
	_total_question_amount_label_of_incorrect.text = string_amount


func set_incorrect_answer_amount(value: int) -> void:
	_incorrect_answers_amount_label.text = String.num(value, 0)


func set_result_flag_texture(value: ResultFlagTextures) -> void:
	var texture = _result_flag_texture_map.get(value)
	_result_flag_texture_rect.texture = texture

#endregion


#region static

static func make_from_result(result: SingleplayerGame.Result) -> GameResultInfo:
	var instantiated_game_result = PRELOADED_SCENE.instantiate()
	
	instantiated_game_result.set_total_question_amount(result.get_total_question_amount())

	instantiated_game_result.set_incorrect_answer_amount(result.get_incorrect_amount())

	var result_flag_texture = result_flag_to_texture(result.get_result_flag())
	instantiated_game_result.set_result_flag_texture(result_flag_texture)

	return instantiated_game_result


static func result_flag_to_texture(result_flag: SingleplayerGame.ResultFlag) -> ResultFlagTextures:
	var texture = ResultFlagTextures.DRAW
	if result_flag == SingleplayerGame.ResultFlag.WIN:
		texture = ResultFlagTextures.WIN
	elif result_flag == SingleplayerGame.ResultFlag.LOSE:
		texture = ResultFlagTextures.LOSE
	return texture
	

#endregion
