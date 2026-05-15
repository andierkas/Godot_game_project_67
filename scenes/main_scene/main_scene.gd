extends Control


func _on_home_button_pressed():
	get_tree().quit()


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/loadgame_scene/loadgame_scene.tscn")


func _on_pref_button_pressed():
	get_tree().change_scene_to_file("res://scenes/preferences_scene/pref_scene.tscn")
