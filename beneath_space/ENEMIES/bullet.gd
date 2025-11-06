extends Area2D

@export var owner_name: String 

var speed: int = 150
var direction = Vector2.RIGHT

func _physics_process(delta):
	position += direction * delta * speed


func _on_body_entered(body: Node2D) -> void:
	if body.name == "locked_axis_enemy":
		return
	queue_free()
	
