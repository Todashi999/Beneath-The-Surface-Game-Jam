extends Area2D


@export var key_id: String = "A" 

var collected := false
@onready var player = get_tree().get_first_node_in_group("PLAYER")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal key_collected(key_id)

func _on_body_entered(body: Node2D) -> void:
	if is_instance_valid(player):
		if body.name == "PLAYER" and not collected:
			collected = true
			key_collected.emit(key_id)
			animation_player.play("fade_out")
