extends Control


func _on_control_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/control_page.tscn")


func _on_play_button_pressed() -> void:
	TransitionScreen.transition("res://scenes/world.tscn")
