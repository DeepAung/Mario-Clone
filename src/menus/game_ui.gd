extends Control


var level_label_str = "Level: %d"
var score_label_str = "Score: %d & %d"

onready var score_label: Label = $"%ScoreLabel"
onready var level_label: Label = $"%LevelLabel"


func _process(delta: float) -> void:
	level_label.text = level_label_str % Game.current_level
	score_label.text = score_label_str % [Game.players[0].score, Game.players[1].score]
