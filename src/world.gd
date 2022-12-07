class_name WorldNode
extends Node


onready var players := {
	"1": {
		viewport = $HBoxContainer/ViewportContainer/Viewport,
		camera = $HBoxContainer/ViewportContainer/Viewport/Camera2D,
		player = null,
	},
	"2": {
		viewport = $HBoxContainer/ViewportContainer2/Viewport,
		camera = $HBoxContainer/ViewportContainer2/Viewport/Camera2D,
		player = null,
	},
}

onready var main_viewport: Viewport = $HBoxContainer/ViewportContainer/Viewport

var current_level = null
var level_path = "res://src/levels/%d.tscn"


func _ready() -> void:
	Game.world = self
	
	current_level = load(level_path % Game.current_level).instance()
	main_viewport.add_child(current_level)
	
	update_player_reference()
	
	players["2"].viewport.world_2d = players["1"].viewport.world_2d
	
	update_remote_transform()


func update_player_reference() -> void:
	for i in players:
		players[i].player = current_level.get_node("Player" + i)


func update_remote_transform() -> void:
	for node in players.values():
		
		var remote_transform = node.player.get_node("RemoteTransform2D")
		remote_transform.remote_path = node.camera.get_path()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	elif event.is_action_pressed("next_level"):
		Game.go_to_next_level()
