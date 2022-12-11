class_name AudioPlayer
extends Node2D


signal finished


const audio_kill_enemy = preload("res://assets/sounds/kill_enemy.wav")
const audio_jump = preload("res://assets/sounds/jump.wav")
const audio_teleport = preload("res://assets/sounds/teleport.wav")
const audio_warp_to_player = preload("res://assets/sounds/warp_to_player.wav")


func play(audio_stream: AudioStream) -> void:
	var sound: AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(sound)

	sound.stream = audio_stream
	sound.play()
	
	yield(sound, "finished")
	sound.queue_free()
	emit_signal("finished")
