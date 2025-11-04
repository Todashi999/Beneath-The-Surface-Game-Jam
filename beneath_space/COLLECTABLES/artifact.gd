extends Area2D

var collected := false
@onready var player = get_tree().get_first_node_in_group("PLAYER")

signal artifact_collected(collected)

func _on_body_entered(body: Node2D) -> void:
	if is_instance_valid(player):
		if body.name == "PLAYER":
			collected = true
			artifact_collected.emit(collected)
			await get_tree().create_timer(1).timeout
			queue_free()
