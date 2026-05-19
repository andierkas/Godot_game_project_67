extends Control

@onready var animMenu : AnimatedSprite2D = $AnimMenu  # Один спрайт для всех анимаций
@onready var animScreen : AnimatedSprite2D = $AnimScreen
@onready var animShadowScreen : AnimatedSprite2D = $Shadow_screen
@onready var playButton : TextureButton = $Play_button
@onready var prefButton : TextureButton = $Pref_button
@onready var offButton : TextureButton = $Off_button
@onready var exitButton : TextureButton = $Exit_button
@onready var playLabel : Label = $Play_label
@onready var prefLabel : Label = $Pref_label
@onready var exitLabel : Label = $Exit_label
@onready var menuStatic: Sprite2D = $Menu

var is_menu_open = false
var is_animating = false  # Флаг, показывающий, что анимация проигрывается

func _ready() -> void:
	animScreen.play("screen_animation")
	hide_buttons()
	offButton.visible = true
	offButton.disabled = false
	
	animMenu.animation_finished.connect(_on_animation_finished)

func hide_buttons() -> void:
	playButton.visible = false
	playButton.disabled = true
	prefButton.visible = false
	prefButton.disabled = true
	exitButton.visible = false
	exitButton.disabled = true
	playLabel.visible = false
	prefLabel.visible = false
	exitLabel.visible = false

func show_buttons() -> void:
	playButton.visible = true
	playButton.disabled = false
	prefButton.visible = true
	prefButton.disabled = false
	exitButton.visible = true
	exitButton.disabled = false
	playLabel.visible = true
	prefLabel.visible = true
	exitLabel.visible = true

func _on_off_button_pressed() -> void:
	# Если анимация уже проигрывается - игнорируем нажатие
	if is_animating:
		return
	
	if is_menu_open:
		# Закрываем меню
		is_animating = true
		animMenu.play("menu_closed_animation")
		animShadowScreen.play("shadow_screen_closed_animation")
		is_menu_open = false
		hide_buttons()
	else:
		# Открываем меню
		is_animating = true
		animMenu.play("menu_opened_animation")
		animShadowScreen.play("shadow_screen_opened_animation")
		is_menu_open = true

func _on_animation_finished() -> void:
	is_animating = false  # Снимаем блокировку
	if is_menu_open:
		# После открытия - показываем кнопки
		show_buttons()

func _on_play_button_pressed() -> void:
	SceneLoader.load_scene("res://scenes/loadgame_scene/loadgame_scene.tscn")

func _on_pref_button_pressed() -> void:
	SceneLoader.load_scene("res://scenes/preferences_scene/pref_scene.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
