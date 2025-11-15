extends CanvasLayer

@onready var main_menu = preload("res://SYSTEMS/SCREEN_UI/main_menu.tscn")
@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer


func _ready() -> void:
	visible = false
	get_tree().paused = false
	#process_mode = Node.PROCESS_MODE_INHERIT
	#process_mode = Node.PROCESS_MODE_PAUSABLE
	#process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	#process_mode = Node.PROCESS_MODE_ALWAYS
	#process_mode = Node.PROCESS_MODE_DISABLED

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			visible = false
			get_tree().paused = false
		else:
			visible = true
			get_tree().paused = true

func _on_button_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_button_2_pressed() -> void:
	#get_tree().paused = false
	#get_tree().change_scene_to_packed(main_menu)
	animation_player.play("default")



func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://SYSTEMS/SCREEN_UI/main_menu.tscn")
