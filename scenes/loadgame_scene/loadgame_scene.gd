extends Control

@onready var animMenu1 : AnimatedSprite2D = $Animated_button_menu
@onready var animMenu2 : AnimatedSprite2D = $Animated_button_menu2
@onready var animMenu3 : AnimatedSprite2D = $Animated_button_menu3
@onready var animScreen : AnimatedSprite2D = $AnimScreen
@onready var hoverSound : AudioStreamPlayer = $Hover_Sound
@onready var pressSound : AudioStreamPlayer = $Press_Sound
@onready var backButton : TextureButton = $Back_Button

func _ready():
	animScreen.play("screen_animation")
	animMenu1.play("button_menu_on")
	animMenu2.play("button_menu_on")
	animMenu3.play("button_menu_on")
	setup_button_sounds()

func _on_back_button_pressed() -> void:
	if pressSound and not pressSound.playing:
		pressSound.pitch_scale = randf_range(0.9, 1.0)
		pressSound.play()
		SceneLoader.load_scene("res://scenes/main_scene/main_scene.tscn")

func _on_back_button_hover() -> void:
	# Проигрываем звук при наведении на кнопки Off и Help
	if hoverSound and not hoverSound.playing:
		hoverSound.pitch_scale = randf_range(0.9, 1.0)
		hoverSound.play()

func setup_button_sounds() -> void:
	# Подключаем звуки для основных кнопок (Play, Pref, Exit)
	if backButton:
		backButton.mouse_entered.connect(_on_back_button_hover)
		backButton.pressed.connect(_on_back_button_pressed)


func _on_back_button_3_pressed() -> void:
	SceneLoader.load_scene("res://scenes/agents_generator_scene/agents_generator.tscn")


func _on_back_button_4_pressed() -> void:
	SceneLoader.load_scene("res://scenes/agents_generator_scene/agents_generator.tscn")


func _on_back_button_5_pressed() -> void:
	SceneLoader.load_scene("res://scenes/agents_generator_scene/agents_generator.tscn")
