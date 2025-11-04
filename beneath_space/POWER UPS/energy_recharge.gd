extends Area2D

@onready var player = get_tree().get_first_node_in_group("PLAYER")


func _on_body_entered(body: Node2D) -> void:
	if is_instance_valid(player):
		if body.name == "PLAYER":
			player.change_energy(-50)
			#PLAY ANIMATION TO QUEUE FREE
