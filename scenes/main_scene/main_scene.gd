extends Control


func _on_home_button_pressed():
	get_tree().quit()


func _on_play_button_pressed():
	SceneLoader.load_scene("res://scenes/loadgame_scene/loadgame_scene.tscn")

func _on_pref_button_pressed():
	SceneLoader.load_scene("res://scenes/preferences_scene/pref_scene.tscn")
