class_name SingleplayerGame extends Node

enum ResultFlag {
	WIN,
	LOSE,
	DRAW
}

const PRELOADED_SCENE = preload("res://src/client/singleplayer/SingleplayerGame.tscn")

var _is_over: bool = false
var _last_result: SingleplayerGameResult
var _game_info: RoundInfo
var _arena: Arena
var _questionare: Questionare
var _local_player: PlayerInfo
var _enemy_player: PlayerInfo
var _round_manager: RoundManager

@export var _timer: Timer

#region builtin

func _ready() -> void:
	assert(_timer != null, "Timer is not set in SingleplayerGame exports")

	_round_manager = RoundManager.new(_timer, _questionare)

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


func get_last_result() -> SingleplayerGameResult:
	return _last_result


func is_questionare_over() -> bool:
	return _questionare.is_ended()


func get_local_player() -> PlayerInfo:
	return _local_player


func get_enemy_player() -> PlayerInfo:
	return _enemy_player


func get_next_round() -> Round:
	var next_round = _round_manager.next()
	return next_round

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
	var round_results = _round_manager.get_round_results()
	_last_result = SingleplayerGameResult.make(_local_player, local_player_character, enemy_character, death_info, round_results)

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
