class_name NormalButton
extends Button


func _ready() -> void:
	connect("pressed", self, "_on_NormalButton_pressed")


func _on_NormalButton_pressed() -> void:
	GlobalAudioPlayer.play(GlobalAudioPlayer.audio_click_button)
