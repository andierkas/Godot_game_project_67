extends CanvasLayer

signal loading_screen_ready

@export var animation_player: AnimationPlayer

func _ready() -> void:
	await animation_player.animation_finished
	loading_screen_ready.emit()
	SceneLoader.load_scene("res://all_scenes/base_scenes/main_scene.tscn")

func _on_proogress_changed(_new_value: float) -> void:
	pass

func _on_load_finished() -> void:
	animation_player.play_backwards("new_animation")
	await animation_player.animation_finished
	queue_free()
