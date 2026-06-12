extends Control

@onready var camera : Camera2D = $Camera2D
@onready var animMenu : AnimatedSprite2D = $Animated_button_menu
@onready var animScreen : AnimatedSprite2D = $AnimScreen
@onready var animShadowScreen : AnimatedSprite2D = $Shadow_screen
@onready var animPlayer : AnimationPlayer = $Show_text_and_buttons/Animation
@onready var offButton : TextureButton = $Off_button
@onready var helpButton : TextureButton = $Help_button

var is_menu_open = false
var is_animating = false
var is_opening = false

func _ready() -> void:
	animScreen.play("screen_animation")
	
	# Запуск анимации меню
	is_animating = true
	is_opening = true
	animMenu.play("button_menu_on")
	animShadowScreen.play("shadow_screen_opened_animation")
	is_menu_open = true
	
	offButton.visible = true
	offButton.disabled = false
	
	animMenu.animation_finished.connect(_on_menu_animation_finished)

func play_buttons_open_animation() -> void:
	if animPlayer:
		animPlayer.play("text_and_button_animation")
		await animPlayer.animation_finished
	
	is_animating = false
	is_opening = false

func play_buttons_close_animation() -> void:
	if animPlayer:
		animPlayer.play_backwards("text_and_button_animation")
		await animPlayer.animation_finished

func _on_menu_animation_finished() -> void:
	if is_opening:
		play_buttons_open_animation()

func _on_off_button_pressed() -> void:
	if is_animating:
		return
	
	if is_menu_open:
		is_animating = true
		await play_buttons_close_animation()
		animMenu.play("button_menu_off")
		animShadowScreen.play("shadow_screen_closed_animation")
		await animMenu.animation_finished
		is_menu_open = false
		is_animating = false
	else:
		is_animating = true
		is_opening = true
		animMenu.play("button_menu_on")
		animShadowScreen.play("shadow_screen_opened_animation")
		is_menu_open = true
		await animMenu.animation_finished
		play_buttons_open_animation()

func _on_play_button_pressed() -> void:
	SceneLoader.load_scene("res://scenes/loadgame_scene/loadgame_scene.tscn")

func _on_pref_button_pressed() -> void:
	SceneLoader.load_scene("res://scenes/preferences_scene/pref_scene.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_help_button_pressed() -> void:
	pass
