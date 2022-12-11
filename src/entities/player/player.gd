tool

class_name Player
extends KinematicBody2D


enum {ENEMY=4, PORTAL=8}

const GRAVITY := 1500.0
const MAX_Y := 400.0
const MOVE_SPEED := 400.0
const ACCEL := 2000.0
const DECEL_FLOOR := 3000.0
const DECEL_AIR := 2000.0
const JUMP_FORCE := 650.0
const STOMP_FORCE := 1000.0

export(Resource) var controls

var gravity_multiply := 1.0

var velocity := Vector2.ZERO
var direction := Vector2.ZERO

var warp_offset := Vector2(-60.0, 0.0)
var spawn_position := Vector2.ZERO
var last_position

var score = 0
var player_index

onready var audio_player: AudioPlayer = $AudioPlayer


func _ready() -> void:
	$Sprite.texture = load(controls.sprite_path)

	if Engine.editor_hint:
		return

	spawn_position = position
	player_index = int(name[-1]) - 1
	if player_index != -1:
		Game.players[player_index] = self


func _physics_process(delta: float) -> void:

	if Engine.editor_hint:
		return

	direction.x = (
		int(Input.is_action_pressed(controls.move_right)) - 
		int(Input.is_action_pressed(controls.move_left))
	)
	
	if direction.x != 0:
		velocity.x = move_toward(velocity.x, direction.x * MOVE_SPEED, ACCEL * delta)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, DECEL_FLOOR * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, DECEL_AIR * delta)
			
	
	if direction.x != 0 and is_on_floor():
		$Particles2D.emitting = true
	else:
		$Particles2D.emitting = false
	
	if Input.is_action_just_pressed(controls.warp):
		var another_player = Game.players[1 - player_index]
		var target_position: Vector2 = another_player.position + warp_offset

		audio_player.play(audio_player.audio_warp_to_player)
		try_warp(target_position)
	
	
	if is_on_floor():
		gravity_multiply = 1.0
		if Input.is_action_just_pressed(controls.move_up):
			audio_player.play(audio_player.audio_jump)
			velocity.y = -JUMP_FORCE
	
	if Input.is_action_just_released(controls.move_up):
		gravity_multiply = 1.5

	
	velocity.y += GRAVITY * gravity_multiply * delta
	
	last_position = position
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_AreaDetector_area_entered(area: Area2D) -> void:

	if Engine.editor_hint:
		return

	if area.get_collision_layer() == ENEMY:
		if global_position.y + 10.0 < area.global_position.y: # enemy died
			audio_player.play(audio_player.audio_kill_enemy)
			score += 1
			velocity.y = -STOMP_FORCE
		else: # player died
			position = spawn_position
	elif area.get_collision_layer() == PORTAL:
		audio_player.play(audio_player.audio_teleport)

		visible = false
		$AreaDetector/CollisionShape2D.disabled = true
		yield(audio_player, "finished")

		if not is_instance_valid(Game.players[1 - player_index]):
			Game.go_to_next_level()
		
		queue_free()


func try_warp(target_position: Vector2) -> void:
	var old_position := position

	position = target_position

	yield(get_tree(), "physics_frame")

	call_deferred("try_warp_deferred", old_position)


func try_warp_deferred(old_position: Vector2) -> void:
	var overlap_size = (
		$WarpDetector.get_overlapping_areas().size()
		 + $WarpDetector.get_overlapping_bodies().size()
	)

	if overlap_size > 1: # exclude player's AreaDetector
		position = old_position

	print($WarpDetector.get_overlapping_areas(), " | ", $WarpDetector.get_overlapping_bodies())


func is_overlap(rect1: Dictionary, rect2: Dictionary) -> bool:
	return (
		rect1.top < rect2.down and rect2.top < rect1.down and 
		rect1.left < rect2.right and rect2.left < rect1.right
	)


func get_rect(pos: Vector2, offset: Vector2) -> Dictionary:
	return {
		top   = pos.y - offset.y,
		down  = pos.y + offset.y,
		left  = pos.x - offset.x,
		right = pos.x + offset.x
	}
