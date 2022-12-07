class_name LevelButton
extends Button


func _on_1_pressed() -> void:
	Game.current_level = int(name)
	get_tree().change_scene("res://src/world.tscn")
