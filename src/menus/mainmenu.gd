extends Control


func _on_StartButton_pressed() -> void:
	get_tree().change_scene("res://src/menus/levels_menu.tscn")


func _on_SettingButton_pressed() -> void:
	pass # Replace with function body.


func _on_ExitButton_pressed() -> void:
	get_tree().quit()
