# ButtonSoundController.gd - простой компонент для звуков кнопок
extends Node

@export var hover_profile: String = ""
@export var press_profile: String = ""
@export var hover_pitch_min: float = 0.9
@export var hover_pitch_max: float = 1.0
@export var press_pitch_min: float = 0.9
@export var press_pitch_max: float = 1.0
@export var use_custom_audio_player: bool = false
@export var custom_hover_player: AudioStreamPlayer = null
@export var custom_press_player: AudioStreamPlayer = null

func _ready():
	var parent_button = get_parent()
	if parent_button is BaseButton:
		# Подключаем только те профили, которые указаны
		if hover_profile != "":
			parent_button.mouse_entered.connect(_on_hover)
		if press_profile != "":
			parent_button.pressed.connect(_on_press)
	else:
		print("ButtonSoundController must be child of a Button!")

func _on_hover():
	if use_custom_audio_player and custom_hover_player:
		if not custom_hover_player.playing:
			custom_hover_player.pitch_scale = randf_range(hover_pitch_min, hover_pitch_max)
			custom_hover_player.play()
	elif hover_profile != "":
		ButtonSound.play_sound(hover_profile)

func _on_press():
	if use_custom_audio_player and custom_press_player:
		custom_press_player.pitch_scale = randf_range(press_pitch_min, press_pitch_max)
		custom_press_player.play()
	elif press_profile != "":
		ButtonSound.play_sound(press_profile)
