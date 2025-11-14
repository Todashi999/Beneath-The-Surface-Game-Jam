extends Area2D

var collected := false
@onready var player = get_tree().get_first_node_in_group("PLAYER")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var key_id: String = "X"

signal key_collected(key_id)


func _on_body_entered(body: Node2D) -> void:
	if is_instance_valid(player):
		if body.name == "PLAYER":
			collected = true
			key_collected.emit(key_id)
			Global.collected_artifacts += 1
			print(Global.collected_artifacts)
