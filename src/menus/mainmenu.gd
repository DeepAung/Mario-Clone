extends Control


var setting_menu_scene = preload("res://src/menus/setting_menu.tscn")


func _on_StartButton_pressed() -> void:
	get_tree().change_scene("res://src/menus/levels_menu.tscn")


func _on_SettingButton_pressed() -> void:
	var setting_menu = setting_menu_scene.instance()
	add_child(setting_menu)


func _on_ExitButton_pressed() -> void:
	get_tree().quit()
