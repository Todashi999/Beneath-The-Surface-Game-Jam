extends CharacterBody2D

@export var bullet_node: PackedScene
var theta: float = 0
@export_range(0,2*PI) var alpha: float = 0.0


@export var not_invincible: bool = false
@export var speed := 100
@onready var player = get_tree().get_first_node_in_group("PLAYER")


var player_pos
var target_pos

var can_move := false

func _physics_process(_delta):
	if is_instance_valid(player):
		player_pos = player.position
		target_pos = (player_pos - position).normalized()
		if can_move:
			velocity = position.direction_to(player_pos) * speed
			look_at(player.position)
			move_and_slide()

func get_vector(angle):
	theta = angle + alpha
	return Vector2(cos(theta), sin(theta))

func shoot(angle):
	var bullet = bullet_node.instantiate()
	
	#bullet.owner_name = "locked_axis_enemy"
	
	bullet.position = global_position
	bullet.direction = get_vector(angle)
	
	get_tree().current_scene.call_deferred("add_child", bullet)


func _on_detection_area_body_entered(body: Node2D) -> void:
	if is_instance_valid(player):
		if body.name == "PLAYER":
			can_move = true
			#var knockback_direction = (player.global_position - global_position).normalized()
			#player.apply_knockback(knockback_direction, 150.0, 1)
#MAKE ON DEATH BULLET HELL


func _on_death_detection_body_entered(body: Node2D) -> void:
	if is_instance_valid(player):
		if body.name == "PLAYER":
			if not_invincible:
				can_move = false
			else:
				var knockback_direction = (player.global_position - global_position).normalized()
				player.apply_knockback(knockback_direction, 150.0, 0.2)


func _on_speed_timeout() -> void:
	if can_move:
		shoot(theta)
