extends CharacterBody2D


#ON READY
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var energy_label: Label = $"energy label"
@onready var energy_timer: Timer = $EnergyTimer

#MOVEMENT VARIABLES
var JUMP_VELOCITY = -300.0
const WALL_JUMP_VELOCITY = -350
var SPEED = 150.0
var acceleration: float = 12.5
var friction: float = 40.5
const AIR_FRICTION: float = 100
var water_accel: float = 1000

var wall_jump_recoil = 300
var wall_slide_gravity = 0.8
var can_wall_jump: bool = true

#DASH 
const DASH_AMOUNT: float = 500.0
const DASH_TIME : float = 0.16

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

var water_movement: bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	energy_label.text = str(energy)

func _physics_process(delta: float) -> void:

	if !is_on_floor():
		if !water_movement:
			velocity.y += gravity * delta
		else:
			velocity.y += gravity * delta * 0.15
	#
	#if is_on_floor():
		#coyote_timer = COYOTE_TIME
	#else:
		#coyote_timer -= delta
	#if dash_cooldown_timer:
	if !is_dashing && !can_dash:
		can_dash = true
		dash_effect()



	var direction := Input.get_axis("left", "right")
	var x_input: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var velocity_weight: float = delta * (acceleration if x_input else friction)
	match water_movement:
		false:
			velocity.x = lerp(velocity.x, x_input * SPEED, velocity_weight)
		true:
			velocity.x = move_toward(velocity.x, direction * SPEED, water_accel * delta)
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	update_state(delta, direction)
	death()
	move_and_slide()

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
	#if Input.is_action_just_pressed("ui_accept"):
		#current_state = JUMP
	
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
		print(jump_buffer_timer, " STARTED")
		match current_state:
			FLOOR:
				if !jump_buffer_timer.is_stopped():
					print(!jump_buffer_timer.is_stopped(), " ISNT STOPPED")
					velocity.y += force
			WATER:
				velocity.y += force
			WALL:
				velocity.y += force
		
	#if Input.is_action_just_pressed("ui_accept"):
		#jump_buffer_timer.start()
	#if current_state == FLOOR && !jump_buffer_timer.is_stopped():
		#velocity.y += force
	#elif current_state == WATER && Input.is_action_just_pressed("ui_accept"):
		#velocity.y += force
		
	#match current_state:
		#FLOOR:
			#if Input.is_action_just_pressed("ui_accept") && coyote_timer > 0:
				#velocity.y = force
				#coyote_timer = 0
		#WATER:
			#if Input.is_action_just_pressed("ui_accept"):
				#velocity.y = force
				#

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
		velocity.x = final_dash_dir.x * DASH_AMOUNT
		velocity.y = final_dash_dir.y * DASH_AMOUNT/2
	
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false


func dash_effect():
	if can_dash:
		modulate = Color("ffffff")
	else:
		modulate = Color("111522")
		

func lerp_movement(bool):
	water_movement = bool

func upade_stats(jump_value, speed_value):
	JUMP_VELOCITY = jump_value
	SPEED = speed_value
	


func _on_energy_timer_timeout() -> void:
	change_energy(1)

func death():
	if energy <= 0:
		queue_free()
