extends Control


func _on_b_play_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_b_exit_button_down() -> void:
	get_tree().quit()
