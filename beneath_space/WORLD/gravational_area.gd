extends Area2D



@onready var player = get_tree().get_first_node_in_group("PLAYER")


func _on_body_entered(body: Node2D) -> void:
	if body.name == "PLAYER":
		print("ENTERED")
		player.lerp_movement(true)


func _on_body_exited(body: Node2D) -> void:
	player.lerp_movement(false)
