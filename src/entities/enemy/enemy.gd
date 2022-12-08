extends KinematicBody2D


const GRAVITY := 1500.0
const MAX_Y := 400.0 
const MOVE_SPEED := 200.0

var velocity := Vector2.ZERO
var direction := Vector2.ZERO


func _ready() -> void:
	direction.x = 1 if Game.players[0].position.x > position.x else -1


func _physics_process(delta: float) -> void:
	
	velocity.x = direction.x * MOVE_SPEED
	velocity.y += GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_wall():
		direction *= -1


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.global_position.y + 10.0 < global_position.y:
		# print(area.global_position.y - 10.0, " ", global_position.y)
		queue_free()

