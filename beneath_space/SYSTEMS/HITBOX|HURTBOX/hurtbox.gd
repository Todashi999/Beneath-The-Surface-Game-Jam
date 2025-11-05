class_name HurtBox
extends Area2D

signal recieved_damage(damage:int)

@export var health: Health

#@onready var robo_mobs = get_tree().get_nodes_in_group("MOB")
@onready var player = get_tree().get_first_node_in_group("PLAYER")

#var hitEffectScene = preload("res://VFX/VFX SCENES/hit_impact_effect.tscn")

func ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: ReuseableHitbox):
	if hitbox != null:
		health.health -= hitbox.damage
		recieved_damage.emit(hitbox.damage)
	if !health.set_immortality(false): 
		#hit_effect()
		pass

#func hit_effect():
	#var hitEffect = hitEffectScene.instantiate()
	#if get_tree():
		#get_tree().current_scene.add_child(hitEffect)
		#hitEffect.global_position = global_position


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
