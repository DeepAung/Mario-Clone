class_name SettingMenu
extends Control


onready var background_music_slider: Slider = $"%BackgroundMusicSlider"
onready var sound_effects_slider: Slider = $"%SoundEffectsSlider"


func _ready():
	background_music_slider.value = AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("BackgroundMusic"))
	sound_effects_slider.value = AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("SoundEffects"))


func _on_BackgroundMusicSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BackgroundMusic"), value)


func _on_SoundEffectsSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), value)


func _on_BackButton_pressed() -> void:
	queue_free()
