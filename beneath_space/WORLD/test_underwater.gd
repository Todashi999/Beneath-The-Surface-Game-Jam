extends Node2D

@onready var transition_animation_player: AnimationPlayer = $CanvasLayer/ColorRect/TransitionAnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transition_animation_player.play("default")
