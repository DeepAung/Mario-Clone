extends AudioStreamPlayer


func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS


func _process(_delta: float) -> void:
	if not playing:
		play()