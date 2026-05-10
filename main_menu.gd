extends Control


func _on_home_button_pressed():
	get_tree().quit()


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://main_scene.tscn")


func _on_pref_button_pressed():
	get_tree().change_scene_to_file("res://pref_scene.tscn")
