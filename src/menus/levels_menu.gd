extends Control


const button = preload("res://src/menus/level_button.tscn")

onready var grid_container: GridContainer = $VBoxContainer/MarginContainer/GridContainer


func _ready() -> void:
	var levels = get_all_levels()
	for level in levels:
		var new_button = button.instance()
		new_button.name = level
		new_button.text = level
		
		grid_container.add_child(new_button)


func get_all_levels():
	var result = []
	
	var dir := Directory.new()
	dir.open("res://src/levels/")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "": break
		
		if not file.begins_with("."):
			result.append(file.get_basename())
	
	dir.list_dir_end()
	
	return result
