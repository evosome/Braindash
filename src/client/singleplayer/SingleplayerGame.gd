class_name SingleplayerGame extends Node

enum ResultFlag {
	WIN,
	LOSE,
	DRAW
}

const PRELOADED_SCENE = preload("res://src/client/singleplayer/SingleplayerGame.tscn")

var _is_over: bool = false
var _last_result: Result
var _game_info: RoundInfo
var _arena: Arena
var _questionare: Questionare
var _local_player: PlayerInfo
var _enemy_player: PlayerInfo

#TODO - is it reaslly good idea to keep round counter and round results like that?
var _round_counter: int = 0
var _round_results: Array[Round.Result] = []

@export var _timer: Timer

#region builtin

func _ready() -> void:
	assert(_timer != null, "Timer is not set in SingleplayerGame exports")

	var packed_arena = _game_info.packed_arena
	if !packed_arena.can_instantiate():
		push_error("Unable to instantiate arena scene")
		return
	
	var instantiated_arena = packed_arena.instantiate()
	add_child(instantiated_arena)
	_arena = instantiated_arena

	_arena.characters_died.connect(_on_characters_died)

#endregion


#region getters/setters

func get_arena() -> Arena:
	return _arena


func is_over() -> bool:
	return _is_over


func get_last_result() -> Result:
	return _last_result


func is_questionare_over() -> bool:
	return _questionare.is_ended()


func get_local_player() -> PlayerInfo:
	return _local_player


func get_enemy_player() -> PlayerInfo:
	return _enemy_player


func get_next_round() -> Round:
	var next_question = _questionare.next()
	_round_counter += 1
	var current_round = Round.new(next_question, _timer, _round_counter)
	current_round.ended.connect(func(r: Round.Result): _round_results.append(r))
	return current_round

#endregion


#region public


func spawn_character_for(player: PlayerInfo, character_type: CharacterType) -> PlayerCharacter:
	if player != _local_player && player != _enemy_player:
		push_error("Unable to spawn character for not existing player: ", player.to_string())
		return
	var player_character = _arena.create_character_for(player, character_type)

	#TODO - is there some elegant way to highlight current player?
	if player == _local_player:
		var player_sprite = player_character.get_sprite()
		player_sprite.set_glowing(true)

		var sprite_aabb = player_character.get_sprite().get_rect()
		var top = player_character.position - Vector2(0, sprite_aabb.size.y / 2) - Vector2(0, 128)
		_arena.show_tip_at(top)
	
	return player_character


## This method is asynchronous. Play fight or draw animation on arena scene
func do_fight(round_result: Round.Result) -> void:

	if round_result.is_draw():
		await _arena.async_draw()
		return

	var smash_info = SmashInfo.new()
	smash_info.set_damage(100)

	var best_answer = round_result.get_best_answer()
	var best_player = best_answer.get_who_answered()
	var best_character = _arena.get_character_of(best_player)
	smash_info.set_winner_character(best_character)

	var loser_players: Array[PlayerInfo]
	var worse_answers = round_result.get_worse_answers()
	loser_players.assign(worse_answers.map(func(a: Question.Answer): return a.get_who_answered()))
	var loser_characters = _arena.get_characters_of(loser_players)

	smash_info.set_loser_characters(loser_characters)
	await _arena.async_smash(smash_info)


## This method is asynchronous. 
func do_health_countdown() -> void:
	pass

#endregion


#region event handlers

func _on_characters_died(death_info: Arena.CharacterDeathInfo) -> void:
	_is_over = true

	var local_player_character = _arena.get_character_of(_local_player)
	var enemy_character = _arena.get_character_of(_enemy_player)
	_last_result = Result.make(_local_player, local_player_character, enemy_character, death_info, _round_results)

#endregion


#region static

static func make(game_info: RoundInfo, local_player: PlayerInfo, enemy_player: PlayerInfo) -> SingleplayerGame:
	var singleplayer_game = PRELOADED_SCENE.instantiate()
	singleplayer_game._game_info = game_info
	singleplayer_game._local_player = local_player
	singleplayer_game._enemy_player = enemy_player
	singleplayer_game._questionare = Questionare.new(game_info.question_list, [local_player, enemy_player])
	return singleplayer_game

#endregion


#region innter classes

class Result:
	extends Resource

	var _local_player_character: PlayerCharacter
	var _enemy_character: PlayerCharacter
	@export var _result_flag: ResultFlag
	@export var _total_question_amount: int
	@export var _correct_amount: int
	@export var _timestamp: float
	
	func _determine_result_flag(death_info: Arena.CharacterDeathInfo) -> ResultFlag:
		var result_flag = ResultFlag.DRAW
		if !death_info.is_all_died():
			var dead_characters = death_info.get_died()
			result_flag = ResultFlag.WIN if not _local_player_character in dead_characters else ResultFlag.LOSE
		return result_flag
	
	func _count_correct_amount(round_results: Array[Round.Result], local_player: PlayerInfo) -> int:
		var correct_count = 0
		for result in round_results:
			var best_answer = result.get_best_answer()
			var best_answerer = best_answer.get_who_answered()
			if best_answerer == local_player:
				correct_count += 1
		return correct_count
	
	func get_result_flag() -> ResultFlag:
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
			round_results: Array[Round.Result]) -> Result:

		var result = Result.new()
		result._local_player_character = local_player_character
		result._enemy_character = enemy_character
		result._result_flag = result._determine_result_flag(death_info)
		result._total_question_amount = round_results.size()
		result._correct_amount = result._count_correct_amount(round_results, local_player)
		result._timestamp = Time.get_unix_time_from_system()
		return result

#endregion
