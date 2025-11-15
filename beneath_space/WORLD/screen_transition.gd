extends Area2D

@onready var underwater_level = preload("res://WORLD/test_underwater.tscn")

@onready var player = get_tree().get_first_node_in_group("PLAYER")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_world_one: bool = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "PLAYER":
		if is_world_one:
			animation_player.play("fade_in")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(underwater_level)
