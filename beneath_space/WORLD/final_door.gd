extends Area2D

@export var door_id: String = "X" 

var door_opened: bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player = get_tree().get_first_node_in_group("PLAYER")
#@onready var global = get_tree().get_script()


func _ready() -> void:
	for key in get_tree().get_nodes_in_group("KEY"):
		key.key_collected.connect(_on_key_key_collected)

func _on_key_key_collected(collected_id: String) -> void:
	if collected_id == door_id:
		door_opened = true
		#player.lerp_movement(true)


func _on_body_entered(body: Node2D) -> void:
	if door_opened and Global.collected_artifacts >= 2:
		if body.name == "PLAYER":
			animation_player.play("fade_in")
