extends Control

func _on_play_pressed() -> void:
	#Start the game by loading the main scene
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	

func _on_quit_pressed() -> void:
	#Close the game
	get_tree().quit()
