class_name SingleplayerGame extends Node

const PRELOADED_SCENE = preload("res://src/client/singleplayer/SingleplayerGame.tscn")

var _is_over: bool = false
var _game_info: RoundInfo
var _arena: Arena
var _questionare: Questionare
var _local_player: PlayerInfo
var _enemy_player: PlayerInfo

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

#endregion

#region getters/setters

func get_local_player() -> PlayerInfo:
	return _local_player


func get_enemy_player() -> PlayerInfo:
	return _enemy_player


func get_next_round() -> Round:
	var next_question = _questionare.next()
	return Round.new(next_question, _timer)

#endregion


#region public

func is_over() -> bool:
	return _is_over


func is_questionare_over() -> bool:
	return _questionare.is_ended()


func spawn_character_for(player: PlayerInfo, character_type: CharacterType) -> void:
	if player != _local_player && player != _enemy_player:
		push_error("Unable to spawn character for not existing player: ", player.to_string())
		return
	_arena.create_character_for(player, character_type)


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

	var worse_answers = round_result.get_worse_answers()
	var loser_players = worse_answers.map(func(a: Question.Answer): return a.get_who_answered())
	var loser_characters = _arena.get_characters_of(loser_players)

	smash_info.set_loser_characters(loser_characters)
	await _arena.async_smash(smash_info)


## This method is asynchronous. 
func do_health_countdown() -> void:
	pass

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
