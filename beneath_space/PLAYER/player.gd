extends CharacterBody2D


#ON READY
@onready var jump_buffer_timer: Timer = $Timers/JumpBufferTimer

@onready var stun_timer: Timer = $Timers/StunTimer
@onready var dash_cooldown_timer: Timer = $Timers/DashCooldownTimer
@onready var energy_label: Label = $"energy label"
@onready var energy_timer: Timer = $Timers/EnergyTimer
@onready var health: Health = $Health
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

#MOVEMENT VARIABLES
var JUMP_VELOCITY = -300.0
const WALL_JUMP_VELOCITY = -350
var SPEED = 150.0
var acceleration: float = 12.5
var friction: float = 10.5
const AIR_FRICTION: float = 100
const WATER_FRICTION: float = 10000
var water_accel: float = 1000

var wall_jump_recoil = 300
var wall_slide_gravity = 0.8
var can_wall_jump: bool = true

#KNOCH BACK
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

#DASH 
const DASH_AMOUNT: float = 500.0
const DASH_TIME : float = 0.4

var can_dash: bool = true
var is_dashing: bool = false
var dash_dir: Vector2 = Vector2.RIGHT
var dash_timer: float = 0.0

#COYOTE
const COYOTE_TIME: float = 0.15
var coyote_timer: float = 0

#ENERGY/HEALTH
@export var max_energy: float 
@export var energy = 100

#STATES
var current_state: int
const FLOOR = 0
const MOVE = 1
const JUMP = 2
const AIR = 3
const DASH = 4
const WALL = 5
const WATER = 6

#ANIMATION
var current_anim: String = ""
var target_anim: String = ""
var anim_hold_timer: float = 0.0  


var water_movement: bool = false
var can_move: bool = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	health.health = energy
	energy_label.text = str(energy)


func _physics_process(delta: float) -> void:

	if !is_on_floor():
		if !water_movement:
			velocity.y += gravity * delta
		else:
			velocity.y += gravity * delta * 0.15

	if !is_dashing && !can_dash:
		can_dash = true
		dash_effect()
	


	var direction := Input.get_axis("left", "right")
	var x_input: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var velocity_weight: float = delta * (acceleration if x_input else friction)
	
	match x_input:
		1.0:
			sprite_flipped(false)
		-1.0:
			sprite_flipped(true)

	if can_move:
		match water_movement:
			false:
				velocity.x = lerp(velocity.x, x_input * SPEED, velocity_weight)
			true:
				velocity.x = move_toward(velocity.x, direction * SPEED, water_accel * delta)

	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		can_move = false
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	else:
		can_move = true
		update_state(delta, direction)
	update_anim()
	move_and_slide()
	death()
	
	if anim_hold_timer > 0.0:
		anim_hold_timer -= delta
		if anim_hold_timer < 0.0:
			anim_hold_timer = 0.0
	
	if target_anim != current_anim:
		anim_player.play(target_anim)
		current_anim = target_anim

func update_anim():
	if anim_hold_timer > 0.0:
		return
		
	if is_dashing:
		target_anim = "spin"
		return
	
	if water_movement:
		if Input.is_action_just_pressed("jump"):
			target_anim = "swim_jump"
		elif abs(velocity.x) < 10 and abs(velocity.y) < 10:
			target_anim = "swim"
		else:
			target_anim = "swim"
		return
	
	if is_on_floor():
		if abs(velocity.x) < 10:
			target_anim = "idle"
		else:
			target_anim = "move"
		return
	
	if velocity.y < 0:
		target_anim = "jump"
	else:
		target_anim = "fall"


func change_energy(amount):
	energy -= amount
	energy_label.text = str(energy)

func update_state(delta, direction):
	
	#DEFINING STATES
	if is_on_floor():
		current_state = FLOOR
	if !is_on_floor() && !water_movement:
		current_state = AIR
	if is_on_wall():
		current_state = WALL
	if water_movement:
		current_state = WATER

	
	match current_state:
		FLOOR:
			check_jump()
			#print("FLOOR", current_state)
		MOVE:
			pass
			#print("MOVE", current_state)
		JUMP:
			pass
			#print("JUMP", current_state)
		AIR:
			velocity.x = move_toward(velocity.x, 0, AIR_FRICTION * delta)
			#print("AIR", current_state)
		DASH:
			pass
			#play_anim("spin")
			#print("DASH", current_state)
		WALL:
			check_wall_jump(direction)
			#print("WALL", current_state)
		WATER:
			check_jump()
			check_dash(delta)


func check_jump():
	match current_state:
		FLOOR:
			input_jump(JUMP_VELOCITY)
		WATER:
			input_jump(JUMP_VELOCITY)


func check_wall_jump(direction):
	match current_state:
		WALL:
			input_jump(WALL_JUMP_VELOCITY)
			#if Input.is_action_just_released("ui_accept"):
				#if direction > 0:
					#velocity.x = -wall_jump_recoil
				#elif direction < 0:
					#velocity.x = wall_jump_recoil


func input_jump(force):
	if Input.is_action_just_pressed("jump"):
		#velocity.y += force
		jump_buffer_timer.start()
		#print(jump_buffer_timer, " STARTED")
		match current_state:
			FLOOR:
				if !jump_buffer_timer.is_stopped():
					#print(!jump_buffer_timer.is_stopped(), " ISNT STOPPED")
					velocity.y += force
					target_anim = "jump"
					anim_hold_timer = 0.25
			WATER:
				velocity.y += force
				if target_anim != "swim_jump":
					target_anim = "swim_jump"
					anim_hold_timer = 0.35
			WALL:
				velocity.y += force
				target_anim = "wall_jump"
				anim_hold_timer = 0.25


func check_dash(delta):
	var input_dir: Vector2 = Vector2(
		Input.get_axis("left", "right"), 
		Input.get_axis("up", "down")).normalized()
	
	if input_dir.x != 0:
		dash_dir.x = input_dir.x
	
	
	if can_dash && Input.is_action_just_pressed("dash"):
		var final_dash_dir: Vector2 = dash_dir
		if input_dir.y != 0 && input_dir.x == 0:
			final_dash_dir.x = 0
		final_dash_dir.y = input_dir.y
	
		can_dash = false
		is_dashing = true
		dash_timer = DASH_TIME
		
		dash_effect()
		change_energy(5)
	
		target_anim = "spin"
		
		velocity.x = final_dash_dir.x * DASH_AMOUNT
		velocity.y = final_dash_dir.y * DASH_AMOUNT/2
	
	if is_dashing:
		dash_timer -= delta
		match input_dir:
			Vector2(0,1):
				if is_dashing:
					global_rotation_degrees = 180
			Vector2(0,-1):
				if is_dashing:
					global_rotation_degrees = 0
			Vector2(1,0):
				if is_dashing:
					global_rotation_degrees = 90
			Vector2(-1,0):
				if is_dashing:
					global_rotation_degrees = -90
		if dash_timer <= 0:
			is_dashing = false


func dash_effect():
	if can_dash:
		modulate = Color("ffffff")
		global_rotation_degrees = 0
		
	else:
		modulate = Color("111522")
		

func lerp_movement(bool):
	water_movement = bool

func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration

func upade_stats(jump_value, speed_value):
	JUMP_VELOCITY = jump_value
	SPEED = speed_value
	

func sprite_flipped(bool):
	sprite.flip_h = bool


func _on_energy_timer_timeout() -> void:
	change_energy(1)

func death():
	if energy <= 0:
		queue_free()


func _on_health_health_depleted() -> void:
	print('ah')


func _on_health_health_changed(diff: int) -> void:
	energy += diff * 5
	energy_label.text = str(energy)
	stun()
	#print(diff, ' ', energy)
	
func stun():
	can_move = false
	stun_timer.start()

func _on_stun_timer_timeout() -> void:
	can_move = true
