class_name Player
extends KinematicBody2D


enum {ENEMY=4, PORTAL=8}

const GRAVITY := 1500.0
const MAX_Y := 400.0
const MOVE_SPEED := 400.0
const ACCEL := 2000.0
const DECEL := 3000.0
const JUMP_FORCE := 650.0
const STOMP_FORCE := 1000.0

export(Resource) var controls

var gravity_multiply := 1.0

var velocity := Vector2.ZERO
var direction := Vector2.ZERO

var last_position

var score = 0


func _ready() -> void:
	Game.players[int(name[-1]) - 1] = self
	
	$Sprite.texture = load(controls.sprite_path)


func _physics_process(delta: float) -> void:
	direction.x = (
		int(Input.is_action_pressed(controls.move_right)) - 
		int(Input.is_action_pressed(controls.move_left))
	)
	
	if direction.x != 0:
		velocity.x = move_toward(velocity.x, direction.x * MOVE_SPEED, ACCEL * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECEL * delta)
	
	
	if is_on_floor():
		gravity_multiply = 1.0
		if Input.is_action_just_pressed(controls.move_up):
			velocity.y = -JUMP_FORCE
	
	if Input.is_action_just_released(controls.move_up):
		gravity_multiply = 1.5

	
	velocity.y += GRAVITY * gravity_multiply * delta
	
	last_position = position
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_AreaDetector_area_entered(area: Area2D) -> void:
	if area.get_collision_layer() == ENEMY and (area.name == "HitBox" or area.name == "HurtBox"):
		if position.y > last_position.y:
			score += 1
			velocity.y = -STOMP_FORCE
		else:
			get_tree().reload_current_scene()
	elif area.get_collision_layer() == PORTAL:
		Game.go_to_next_level()
