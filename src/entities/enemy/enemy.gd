class_name Enemy
extends KinematicBody2D


const GRAVITY := 1500.0
const MAX_Y := 400.0 
const MOVE_SPEED := 200.0

var velocity := Vector2.ZERO
var direction := Vector2.ZERO
var died = false


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
		destroy()


func destroy() -> void:

	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ZERO, 1.0)

	yield(tween, "finished")
	queue_free()
