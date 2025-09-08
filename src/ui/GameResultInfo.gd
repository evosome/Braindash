class_name GameResultInfo extends AbstractPopup

enum ResultFlagTextures {
	WIN,
	LOSE,
	DRAW
}

const PRELOADED_SCENE = preload("GameResultInfo.tscn")

@export var _ok_button: Button
@export var _result_flag: GameResultBadge
@export var _total_question_amount_label: Label
@export var _incorrect_answers_amount_label: Label
@export var _total_question_amount_label_of_incorrect: Label
@export var _enemy_character_icon: CharacterIcon
@export var _player_character_icon: CharacterIcon


#region builtin

func _ready() -> void:
	_ok_button.pressed.connect(_on_ok_button_pressed)

#endregion


#region public

func set_total_question_amount(value: int) -> void:
	var string_amount = String.num(value, 0)
	_total_question_amount_label.text = string_amount
	_total_question_amount_label_of_incorrect.text = string_amount


func set_incorrect_answer_amount(value: int) -> void:
	_incorrect_answers_amount_label.text = String.num(value, 0)


func set_result_flag_texture(value: GameResultBadge.PopupBadges) -> void:
	_result_flag.set_badge(value)


func set_player_character(character: PlayerCharacter) -> void:
	var char_type = character.get_type()
	_player_character_icon.set_icon_texture(char_type.kind_icon)


func set_enemy_character(character: PlayerCharacter) -> void:
	var char_type = character.get_type()
	_enemy_character_icon.set_icon_texture(char_type.kind_icon)

#endregion


#region static

static func make_from_result(result: SingleplayerGameResult) -> GameResultInfo:
	var instantiated_game_result = PRELOADED_SCENE.instantiate()
	
	instantiated_game_result.set_total_question_amount(result.get_total_question_amount())

	instantiated_game_result.set_incorrect_answer_amount(result.get_correct_amount())

	var result_flag_texture = result_flag_to_texture(result.get_result_flag())
	instantiated_game_result.set_result_flag_texture(result_flag_texture)
	
	var enemy_character = result.get_enemy_character()
	instantiated_game_result.set_enemy_character(enemy_character)
	
	var player_character = result.get_local_player_character()
	instantiated_game_result.set_player_character(enemy_character)

	return instantiated_game_result


static func result_flag_to_texture(result_flag: SingleplayerGame.ResultFlag) -> GameResultBadge.PopupBadges:
	var texture = GameResultBadge.PopupBadges.DRAW
	if result_flag == SingleplayerGame.ResultFlag.WIN:
		texture = GameResultBadge.PopupBadges.WIN
	elif result_flag == SingleplayerGame.ResultFlag.LOSE:
		texture = GameResultBadge.PopupBadges.LOSE
	return texture

#endregion


#region event handlers

func _on_ok_button_pressed() -> void:
	close()

#endregion
