extends Control


func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	visible = false
	get_tree().paused = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if visible:
			visible = false
			get_tree().paused = false
		else:
			visible = true
			get_tree().paused = true


func _on_ResumeButton_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_RestartButton_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_SettingButton_pressed() -> void:
	pass # Replace with function body.


func _on_ExitButton_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://src/menus/mainmenu.tscn")
