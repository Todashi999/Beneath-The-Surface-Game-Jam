extends AnimatableBody2D

var door_opened: bool = false

func _on_key_key_collected(collected: Variant) -> void:
	if collected:
		door_opened = true


func _on_door_detection_body_entered(body: Node2D) -> void:
	if door_opened:
		queue_free()
