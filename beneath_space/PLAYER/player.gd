extends CharacterBody2D


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

func _physics_process(delta: float) -> void:

	if !is_on_floor():
		if !water_movement:
			velocity.y += gravity * delta
		else:
			print(water_movement)
			velocity.y += gravity * delta * 0.25
	
	#match current_state:
		#FLOOR:
			#velocity += get_gravity() * delta
		#AIR:
			#velocity += get_gravity() * delta
		#WATER:
			#velocity += get_gravity() * delta * 0.9
	
	var direction := Input.get_axis("ui_left", "ui_right")
	var x_input: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
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
	move_and_slide()

func update_state(delta, direction):
	
	#DEFINING STATES
	if is_on_floor():
		current_state = FLOOR
	if !is_on_floor() && water_movement == false:
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
			check_dash()
			#print("DASH", current_state)
		WALL:
			check_wall_jump(direction)
			#print("WALL", current_state)
		WATER:
			check_jump()
			check_movement()


func check_jump():
	match current_state:
		FLOOR:
			input_jump(JUMP_VELOCITY)
		WATER:
			input_jump(JUMP_VELOCITY)
		#AIR:
			#if velocity.y > 0.0:
				#if Input.is_action_just_released("ui_accept"):
					#velocity.y *= 0.2
					#print("JUST RELEASED")

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
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = force

func check_dash():
	pass

func lerp_movement(bool):
	water_movement = bool
	print(water_movement)

func check_movement():
	JUMP_VELOCITY = -100
	
