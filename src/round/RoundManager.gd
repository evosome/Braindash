class_name RoundManager

var _questionare: Questionare
var _external_timer: Timer
var _round_counter: int = 0
var _round_results: Array[Round.Result] = []


#region constructor

func _init(external_timer: Timer, questionare: Questionare) -> void:
    _external_timer = external_timer
    _questionare = questionare

#endregion


#region public

func next() -> Round:
    _round_counter += 1
    var next_question = _questionare.next()
    var new_round = Round.new(next_question, _external_timer, _round_counter)
    new_round.ended.connect(_on_round_over.bind(new_round))
    return new_round


func get_round_results() -> Array[Round.Result]:
    return _round_results

#endregion


#region event handlers

func _on_round_over(result: Round.Result, ended_round: Round) -> void:
    _round_results.append(result)
    ended_round.ended.disconnect(_on_round_over)

#endregion
