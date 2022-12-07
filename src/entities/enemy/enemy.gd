extends KinematicBody2D


const GRAVITY := 1500.0
const MAX_Y := 400.0 
const MOVE_SPEED := 200.0

var velocity := Vector2.ZERO
var direction := Vector2.ZERO

onready var hit_box: Area2D = $HitBox
onready var hurt_box: Area2D = $HurtBox


func _ready() -> void:
	direction.x = 1 if Game.players[0].position.x > position.x else -1


func _physics_process(delta: float) -> void:
	
	velocity.x = direction.x * MOVE_SPEED
	velocity.y += GRAVITY * delta
	
	move_and_slide(velocity, Vector2.UP)
	
	if is_on_wall():
		direction *= -1


func _on_HurtBox_area_entered(area: Area2D) -> void:
	queue_free()
