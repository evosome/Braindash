class_name SingleplayerGameResult extends Resource

var _local_player_character: PlayerCharacter
var _enemy_character: PlayerCharacter
@export var _result_flag: SingleplayerGame.ResultFlag
@export var _total_question_amount: int
@export var _correct_amount: int
@export var _timestamp: float

func _determine_result_flag(death_info: Arena.CharacterDeathInfo) -> SingleplayerGame.ResultFlag:
    var result_flag = SingleplayerGame.ResultFlag.DRAW
    if !death_info.is_all_died():
        var dead_characters = death_info.get_died()
        result_flag = SingleplayerGame.ResultFlag.WIN if not _local_player_character in dead_characters else SingleplayerGame.ResultFlag.LOSE
    return result_flag

func _count_correct_amount(round_results: Array[Round.Result], local_player: PlayerInfo) -> int:
    var correct_count = 0
    for result in round_results:
        var best_answer = result.get_best_answer()
        var best_answerer = best_answer.get_who_answered()
        if best_answerer == local_player:
            correct_count += 1
    return correct_count

func get_result_flag() -> SingleplayerGame.ResultFlag:
    return _result_flag

func get_local_player_character() -> PlayerCharacter:
    return _local_player_character

func get_enemy_character() -> PlayerCharacter:
    return _enemy_character

func get_total_question_amount() -> int:
    return _total_question_amount

func get_correct_amount() -> int:
    return _correct_amount

func get_timestamp() -> float:
    return _timestamp

static func make(
        local_player: PlayerInfo,
        local_player_character: PlayerCharacter,
        enemy_character: PlayerCharacter,
        death_info: Arena.CharacterDeathInfo,
        round_results: Array[Round.Result]) -> SingleplayerGameResult:

    var result = SingleplayerGameResult.new()
    result._local_player_character = local_player_character
    result._enemy_character = enemy_character
    result._result_flag = result._determine_result_flag(death_info)
    result._total_question_amount = round_results.size()
    result._correct_amount = result._count_correct_amount(round_results, local_player)
    result._timestamp = Time.get_unix_time_from_system()
    return result