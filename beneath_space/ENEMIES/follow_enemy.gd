extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("PLAYER")

var player_pos
var target_pos
var speed := 100

var can_move := false

func _physics_process(_delta):
	if is_instance_valid(player):
		player_pos = player.position
		target_pos = (player_pos - position).normalized()
		if can_move:
			velocity = position.direction_to(player_pos) * speed
			look_at(player.position)
			move_and_slide()
		
func _on_detection_area_body_entered(body: Node2D) -> void:
	if is_instance_valid(player):
		if body.name == "PLAYER":
			can_move = true

#MAKE ON DEATH BULLET HELL
