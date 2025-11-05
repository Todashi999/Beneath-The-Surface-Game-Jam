extends Node2D




func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://WORLD/test_world.tscn")


func _on_options_pressed() -> void:
	$MenuInputManager.open_menu($Settings,$HBoxContainer/VBoxContainer/options)


func _on_back_to_menu_pressed() -> void:
	$MenuInputManager.close_menu()


func _on_settings_1_pressed() -> void:
	$MenuInputManager.open_menu($options1, $Settings/VBoxContainer/SETTINGS_1)


func _on_exit_pressed() -> void:
	$MenuInputManager.close_menu()


func _on_exit_game_pressed() -> void:
	get_tree().quit()
