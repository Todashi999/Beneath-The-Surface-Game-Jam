extends Area2D

@onready var player = get_tree().get_first_node_in_group("PLAYER")
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_body_entered(body: Node2D) -> void:
	if is_instance_valid(player):
		if body.name == "PLAYER":
			player.change_energy(-50)
			animation_player.play("collected")
			#PLAY ANIMATION TO QUEUE FREE

			animation_player.queue("default")

func play_anim():
	animation_player.play("default")
