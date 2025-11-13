extends Area2D

@export var owner_name: String 

@onready var player = get_tree().get_first_node_in_group("PLAYER")
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var speed: int = 150
var direction = Vector2.RIGHT

func _physics_process(delta):
	position += direction * delta * speed


func _on_body_entered(body: Node2D) -> void:
	if body.name == "locked_axis_enemy":
		return
	if body.name == "follow_enemy":
		return
	if body.name == "PLAYER":
		var knockback_direction = (player.global_position - global_position).normalized()
		player.apply_knockback(knockback_direction, 150.0, 0.12)
	animation_player.play("fade_out")
	
