extends CharacterBody2D


@export var x_value: float
@export var y_value: float

@export var direction: Vector2
@export var movement_speed: int

@onready var floor_detection: RayCast2D = $FloorDetection
@onready var ceiling_detection: RayCast2D = $CeilingDetection
@onready var wall_detection: RayCast2D = $WallDetection
@onready var wall_detection_2: RayCast2D = $WallDetection2


var prev_floor_col := false
var prev_ceil_col := false
var prev_wall_col := false
var prev_wall_col_2 := false

func _physics_process(delta: float) -> void:
	var chance = randi() % 4
	
	
	velocity.x = direction.x * movement_speed
	velocity.y = direction.y * movement_speed
	
	var floor_col = floor_detection.is_colliding()
	var ceil_col = ceiling_detection.is_colliding()
	var wall_col = wall_detection.is_colliding()
	var wall_col_2 =  wall_detection_2.is_colliding()
	
	if floor_col && !prev_floor_col:
		direction.y *= -1
	if ceil_col && !prev_ceil_col:
		direction.y *= -1
	if (wall_col && !prev_wall_col) || (wall_col_2 && !prev_wall_col_2):
		direction.x *= -1
		
	
	prev_floor_col = floor_col
	prev_ceil_col = ceil_col
	prev_wall_col = wall_col
	prev_wall_col_2 =  wall_col_2
	
	#
	#match chance:
		#0:
			#change_dir(1,0)
		#1:
			#change_dir(0,1)
		#2:
			#change_dir(-1,0)
		#3:
			#change_dir(0,-1)
	move_and_slide()

func change_dir(x_value, y_value):
	direction = Vector2(x_value, y_value)
	
	
