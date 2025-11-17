extends AnimatedSprite2D


func UpdateAlpha(newValue: float) -> void:
	modulate.a = newValue

func StartFading() -> void:
	var newTween = get_tree().create_tween()
	newTween.tween_method(UpdateAlpha, 0.8, 0.0, 1.0)
