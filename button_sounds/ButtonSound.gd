extends Node

var sound_profiles = {}

func _ready():
	register_sound_profile("electro_hover", "res://button_sounds/sounds/el_button_hover.mp3", 0.9, 1.0)
	register_sound_profile("electro_press", "res://button_sounds/sounds/el_button_pressed.wav", 0.9, 1.0)
	register_sound_profile("pc_hover", "res://button_sounds/sounds/pc_button_hover.mp3", 0.9, 1.0)
	register_sound_profile("pc_press", "res://button_sounds/sounds/pc_button_pressed.wav", 0.9, 1.0)

func register_sound_profile(profile_name: String, sound_path: String, min_pitch: float = 0.9, max_pitch: float = 1.1):
	sound_profiles[profile_name] = {
		"path": sound_path,
		"min_pitch": min_pitch,
		"max_pitch": max_pitch
	}

func play_sound(profile_name: String, audio_player: AudioStreamPlayer = null):
	var profile = sound_profiles[profile_name]
	
	if audio_player:
		if not audio_player.playing:
			audio_player.pitch_scale = randf_range(profile.min_pitch, profile.max_pitch)
			audio_player.play()
	else:
		var temp_player = AudioStreamPlayer.new()
		temp_player.stream = load(profile.path)
		temp_player.pitch_scale = randf_range(profile.min_pitch, profile.max_pitch)
		add_child(temp_player)
		temp_player.play()
		await temp_player.finished
		temp_player.queue_free()
