extends Control


var level_label_str = "Level: %d"
var score_label_str = "Score P1: %d\nScore P2: %d"

onready var score_label: Label = $"%ScoreLabel"
onready var level_label: Label = $"%LevelLabel"

var players_score = [0, 0]


func _process(delta: float) -> void:
	level_label.text = level_label_str % Game.current_level

	if is_instance_valid(Game.players[0]):
		players_score[0] = int(Game.players[0].score)
	if is_instance_valid(Game.players[1]):
		players_score[1] = int(Game.players[1].score)

	score_label.text = score_label_str % [players_score[0], players_score[1]]
