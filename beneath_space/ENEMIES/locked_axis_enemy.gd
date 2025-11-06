extends CharacterBody2D

@export var bullet_node: PackedScene
var theta: float = 0
@export_range(0,2*PI) var alpha: float = 0.0

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
	
	move_and_slide()

func change_dir(x_value, y_value):
	direction = Vector2(x_value, y_value)

func get_vector(angle):
	theta = angle + alpha
	return Vector2(cos(theta), sin(theta))

func shoot(angle):
	var bullet = bullet_node.instantiate()
	
	#bullet.owner_name = "locked_axis_enemy"
	
	bullet.position = global_position
	bullet.direction = get_vector(angle)
	
	get_tree().current_scene.call_deferred("add_child", bullet)


func _on_speed_timeout():
	shoot(theta)
