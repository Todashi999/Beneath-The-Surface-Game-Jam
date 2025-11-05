class_name ReuseableHitbox
extends Area2D

@export var damage: int = 1 : set = set_damage, get = get_damage


func set_damage(value: int):
	damage = value


func get_damage() -> int:
	return damage

func disable_hitbox():
	$CollisionShape2D.disabled = true

func enable_hitbox():
	$CollisionShape2D.disabled = false
