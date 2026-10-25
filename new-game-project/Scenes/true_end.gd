extends Control


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().quit()
