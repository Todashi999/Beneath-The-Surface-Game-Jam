extends CharacterBody2D


#MOVEMENT VARIABLES
const JUMP_VELOCITY = -400.0
const WALL_JUMP_VELOCITY = -200
var SPEED = 200.0
var acceleration: float = 12.5
var friction: float = 40.5
const AIR_FRICTION: float = 100

#STATES
var current_state: int
const FLOOR = 0
const MOVE = 1
const JUMP = 2
const AIR = 3
const DASH = 4
const WALL = 5


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction := Input.get_axis("ui_left", "ui_right")
	var x_input: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var velocity_weight: float = delta * (acceleration if x_input else friction)
	velocity.x = lerp(velocity.x, x_input * SPEED, velocity_weight)
	#velocity.x = move_toward(velocity.x, direction * SPEED, acceleration * delta)

	

	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	
	update_state(delta)
	move_and_slide()

func update_state(delta):
	
	#DEFINING STATES
	if is_on_floor():
		current_state = FLOOR
	if !is_on_floor():
		current_state = AIR
	if is_on_wall():
		current_state = WALL
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
			check_wall_jump()
			#print("WALL", current_state)
			


func check_jump():
	match current_state:
		FLOOR:
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = JUMP_VELOCITY
		AIR:
			if velocity.y > 0.0:
				if Input.is_action_just_released("ui_accept"):
					velocity.y *= 0.2
					print("JUST RELEASED")

func check_wall_jump():
	match current_state:
		WALL:
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = WALL_JUMP_VELOCITY
				if Input.is_action_just_released("ui_accept"):
					velocity.x = 100

func check_dash():
	pass
