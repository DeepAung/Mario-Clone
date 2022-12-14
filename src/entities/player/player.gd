tool

class_name Player
extends KinematicBody2D


enum {ENEMY=4, PORTAL=8}

const GRAVITY := 1600.0
const MAX_Y := 2700.0
const MOVE_SPEED := 400.0
const ACCEL := 2000.0
const DECEL_FLOOR := 3000.0
const DECEL_AIR := 2000.0
const JUMP_FORCE := 650.0
const STOMP_FORCE := 1000.0
const HYPER_JUMP_FORCE := 250.0

const COYOTE_FRAME := 2
const JUMP_BUFFER_FRAME := 6
const HYPER_JUMP_FRAME := 3

const warp_detector_scene := preload("res://src/entities/player/warp_detector.tscn")

export(Resource) var controls

var gravity_multiply := 1.0
var warp_offset := Vector2(-60.0, 0.0)

var velocity := Vector2.ZERO
var direction := Vector2.ZERO
var spawn_position := Vector2.ZERO
var _target_position := Vector2.ZERO
var last_position := Vector2.ZERO

var can_jump = false
var can_jump_buffer = false
var can_hyper_jump_buffer = false
var freezing = false

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

	if Engine.editor_hint or freezing:
		return

	direction.x = (
		int(Input.is_action_pressed(controls.move_right)) - 
		int(Input.is_action_pressed(controls.move_left))
	)

	can_jump_handler()
	
	move_handler(delta)
	
	warp_handler()

	jump_buffer_handler()
	
	jump_handler()
	
	particle_handler()
	
	last_position = position

	velocity.y += GRAVITY * gravity_multiply * delta
	velocity.y = min(velocity.y, MAX_Y)
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_AreaDetector_area_entered(area: Area2D) -> void:

	if Engine.editor_hint:
		return

	if area.get_collision_layer() == ENEMY:
		var enemy: Enemy = area.get_parent()
		if not enemy.died and global_position.y + 10.0 < area.global_position.y: # enemy died
			enemy.died = true

			audio_player.play(audio_player.audio_kill_enemy)
			score += 1
			velocity.y = -STOMP_FORCE
			check_hyper_jump()
		else: # player died
			audio_player.play(audio_player.audio_plyer_died)
			position = spawn_position
	elif area.get_collision_layer() == PORTAL:
		call_deferred("freeze_player")

		audio_player.play(audio_player.audio_teleport)
		yield(audio_player, "finished")

		if not is_instance_valid(Game.players[1 - player_index]):
			Game.go_to_next_level()
		
		queue_free()


func freeze_player() -> void:
	visible = false
	$AreaDetector/CollisionShape2D.disabled = true
	velocity = Vector2.ZERO
	freezing = true


func can_jump_handler() -> void:
	if is_on_floor():
		can_jump = true
		gravity_multiply = 1.0
	else:
		yield(get_tree().create_timer(COYOTE_FRAME / 60.0), "timeout")
		can_jump = false


func move_handler(delta: float) -> void:
	if direction.x != 0:
		velocity.x = move_toward(velocity.x, direction.x * MOVE_SPEED, ACCEL * delta)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, DECEL_FLOOR * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, DECEL_AIR * delta)


func particle_handler() -> void:
	if direction.x != 0 and is_on_floor():
		$Particles2D.emitting = true
	else:
		$Particles2D.emitting = false


func warp_handler() -> void:
	if Input.is_action_just_pressed(controls.warp):
		var another_player = Game.players[1 - player_index]

		if not is_instance_valid(another_player) or another_player.freezing:
			audio_player.play(audio_player.audio_can_not_warp)
			return
		
		var target_position: Vector2 = another_player.global_position + warp_offset
		
		var result = yield(can_warp(target_position), "completed")
		if result:
			audio_player.play(audio_player.audio_can_warp)
			global_position = target_position
		else:
			audio_player.play(audio_player.audio_can_not_warp)


func jump_buffer_handler() -> void:
	if can_jump and can_jump_buffer:
		jump()


func jump_handler() -> void:
	if Input.is_action_just_pressed(controls.move_up):
		if can_jump:
			jump()
		else:
			set_jump_buffer()
	
	if is_on_floor():
		gravity_multiply = 1.0
	if (not is_on_floor() and velocity.y > 0) or Input.is_action_just_released(controls.move_up):
		gravity_multiply = 1.5


func can_warp(target_position: Vector2) -> void:
	var warp_detector: WarpDetector = warp_detector_scene.instance()

	get_parent().add_child(warp_detector)
	warp_detector.global_position = target_position
	yield(get_tree(), "physics_frame")

	var overlaps := warp_detector.get_overlapping_areas() + warp_detector.get_overlapping_bodies()
	warp_detector.queue_free()

	for node in overlaps:
		if node.is_in_group("tile_maps"):
			return false

	return true


func check_hyper_jump() -> void:
	if can_jump_buffer:
		hyper_jump()
		return
	
	for _i in range(HYPER_JUMP_FRAME):
		if Input.is_action_just_pressed(controls.move_up):
			hyper_jump()
			return
		yield(get_tree(), "idle_frame")


func set_jump_buffer() -> void:
	can_jump_buffer = true
	yield(get_tree().create_timer(JUMP_BUFFER_FRAME / 60.0), "timeout")
	can_jump_buffer = false


func jump() -> void:
	can_jump = false
	can_jump_buffer = false
	audio_player.play(audio_player.audio_jump)
	velocity.y = -JUMP_FORCE


func hyper_jump() -> void:
	$HyperJumpParticle.emitting = true
	$HyperJumpParticle2.emitting = true
	audio_player.play(audio_player.audio_jump)
	
	can_jump = false
	can_jump_buffer = false
	velocity.y += -HYPER_JUMP_FORCE
