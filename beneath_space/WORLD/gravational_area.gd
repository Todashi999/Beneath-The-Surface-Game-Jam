extends Area2D



@onready var player = get_tree().get_first_node_in_group("PLAYER")


func _on_body_entered(body: Node2D) -> void:
	if is_instance_valid(player):
		if body.name == "PLAYER":
			player.lerp_movement(true)
			player.upade_stats(-100, 100)
			player.energy_timer.start()



func _on_body_exited(body: Node2D) -> void:
	if is_instance_valid(player):
		if body.name == "PLAYER" and body.is_inside_tree():
			player.lerp_movement(false)
			player.upade_stats(-300, 150)
			player.energy_timer.stop()
	
