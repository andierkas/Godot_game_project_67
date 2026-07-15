extends Control

@onready var animMenu1 : AnimatedSprite2D = $Animated_button_menu1
@onready var animMenu2 : AnimatedSprite2D = $Animated_button_menu2
@onready var animMenu3 : AnimatedSprite2D = $Animated_button_menu3
@onready var animPlayer : AnimationPlayer = $Show_buttons/Animation
@onready var animScreen : AnimatedSprite2D = $AnimScreen

func _ready():
	animScreen.play("screen_animation")
	animMenu1.play("button_menu_on")
	animMenu2.play("button_menu_on")
	animMenu3.play("button_menu_on")
	animPlayer.play("buttons_show")


func _on_save_button_1_pressed() -> void:
	SceneLoader.load_scene("res://all_scenes/base_scenes/agents_generator.tscn")


func _on_save_button_2_pressed() -> void:
	SceneLoader.load_scene("res://all_scenes/base_scenes/agents_generator.tscn")


func _on_save_button_3_pressed() -> void:
	SceneLoader.load_scene("res://all_scenes/base_scenes/agents_generator.tscn")


func _on_back_button_pressed() -> void:
	SceneLoader.load_scene("res://all_scenes/base_scenes/main_scene.tscn")
