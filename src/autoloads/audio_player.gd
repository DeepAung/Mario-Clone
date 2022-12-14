class_name AudioPlayer
extends Node2D


signal finished


const audio_kill_enemy = preload("res://assets/sounds/kill_enemy.wav")
const audio_jump = preload("res://assets/sounds/jump.wav")
const audio_teleport = preload("res://assets/sounds/teleport.wav")
const audio_can_warp = preload("res://assets/sounds/can_warp.wav")
const audio_can_not_warp = preload("res://assets/sounds/can_not_warp.wav")
const audio_plyer_died = preload("res://assets/sounds/player_died.wav")
const audio_click_button = preload("res://assets/sounds/click_button.wav")


func play(audio_stream: AudioStream) -> void:
	var sound: AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(sound)

	sound.bus = "SoundEffects"
	sound.stream = audio_stream
	sound.play()
	
	yield(sound, "finished")
	sound.queue_free()
	emit_signal("finished")
