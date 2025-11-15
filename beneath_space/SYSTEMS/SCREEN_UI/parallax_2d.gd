extends Parallax2D

@export var speed: float = 100.0  # scrolling speed

func _process(delta: float) -> void:
	scroll_offset.x += speed * delta
