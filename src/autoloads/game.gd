extends Node


var level_path = "res://src/levels/%d.tscn"
var current_level = 1
var current_score = 0

var players = [null, null]
var world = null

func go_to_next_level():
	world = world as WorldNode
	
	var parent = world.current_level.get_parent()
	
	world.current_level.queue_free()
	
	var next_level = load(level_path % (current_level + 1))
	if next_level != null:
		world.current_level = next_level.instance()
		call_deferred("add_level", parent)
		
		world.update_player_reference()
		world.update_remote_transform()

		current_level += 1
	else:
		get_tree().change_scene("res://src/menus/mainmenu.tscn")
		current_level = 1


func add_level(parent: Node):
	parent.add_child(world.current_level)
