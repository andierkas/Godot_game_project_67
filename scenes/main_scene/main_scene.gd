extends Control

@onready var animMenu : AnimatedSprite2D = $Animated_button_menu  # Один спрайт для всех анимаций
@onready var animScreen : AnimatedSprite2D = $AnimScreen
@onready var animShadowScreen : AnimatedSprite2D = $Shadow_screen
@onready var animPlayer : AnimationPlayer = $Show_text_and_buttons/Animation
@onready var playButton : TextureButton = $Show_text_and_buttons/Play_button
@onready var prefButton : TextureButton = $Show_text_and_buttons/Pref_button
@onready var exitButton : TextureButton = $Show_text_and_buttons/Exit_button
@onready var offButton : TextureButton = $Off_button
@onready var helpButton : TextureButton = $Help_button
@onready var playLabel : Label = $Play_label
@onready var prefLabel : Label = $Pref_label
@onready var exitLabel : Label = $Exit_label
@onready var hoverSound : AudioStreamPlayer = $ButtonHoverSound
@onready var pressSound : AudioStreamPlayer = $ButtonPressSound
@onready var hoverOffHelpSound : AudioStreamPlayer = $OffHelpHoverSound
@onready var pressOffHelpSound : AudioStreamPlayer = $OffHelpPressSound

var is_menu_open = false
var is_animating = false  # Флаг, показывающий, что анимация проигрывается
var is_opening = false  # Флаг для отслеживания процесса открытия

func _ready() -> void:
	animScreen.play("screen_animation")
	
	# Сразу запускаем анимацию открытия меню
	is_animating = true
	is_opening = true
	animMenu.play("button_menu_on")
	animShadowScreen.play("shadow_screen_opened_animation")
	is_menu_open = true
	
	# Скрываем кнопки до завершения анимации
	offButton.visible = true
	offButton.disabled = false
	
	# Подключаем звуковые эффекты для всех кнопок
	setup_button_sounds()
	
	animMenu.animation_finished.connect(_on_menu_animation_finished)

func setup_button_sounds() -> void:
	# Подключаем звуки для основных кнопок (Play, Pref, Exit)
	if playButton:
		playButton.mouse_entered.connect(_on_button_hover)
		playButton.pressed.connect(_on_button_press)
	
	if prefButton:
		prefButton.mouse_entered.connect(_on_button_hover)
		prefButton.pressed.connect(_on_button_press)
	
	if exitButton:
		exitButton.mouse_entered.connect(_on_button_hover)
		exitButton.pressed.connect(_on_button_press)
	
	# Подключаем звуки для кнопки Off (свои звуки)
	if offButton:
		offButton.mouse_entered.connect(_on_off_help_hover)
		offButton.pressed.connect(_on_off_help_press)
	
	# Подключаем звуки для кнопки Help (свои звуки)
	if helpButton:
		helpButton.mouse_entered.connect(_on_off_help_hover)
		helpButton.pressed.connect(_on_off_help_press)

func _on_button_hover() -> void:
	# Проигрываем звук при наведении на основные кнопки
	if hoverSound and not hoverSound.playing:
		hoverSound.pitch_scale = randf_range(0.9, 1.1)
		hoverSound.play()

func _on_button_press() -> void:
	# Проигрываем звук при нажатии на основные кнопки
	if pressSound:
		pressSound.pitch_scale = randf_range(0.95, 1.05)
		pressSound.play()

func _on_off_help_hover() -> void:
	# Проигрываем звук при наведении на кнопки Off и Help
	if hoverOffHelpSound and not hoverOffHelpSound.playing:
		hoverOffHelpSound.pitch_scale = randf_range(0.9, 1.1)
		hoverOffHelpSound.play()

func _on_off_help_press() -> void:
	# Проигрываем звук при нажатии на кнопки Off и Help
	if pressOffHelpSound:
		pressOffHelpSound.pitch_scale = randf_range(0.95, 1.05)
		pressOffHelpSound.play()

func play_buttons_open_animation() -> void:
	# Запускаем анимацию из AnimationPlayer
	if animPlayer:
		animPlayer.play("text_and_button_animation")
		# Ждем завершения анимации
		await animPlayer.animation_finished
	
	# После завершения анимации показываем кнопки (если они были скрыты в анимации)
	is_animating = false
	is_opening = false

func play_buttons_close_animation() -> void:
	# Если анимация проигрывается в обратную сторону, можно использовать:
	if animPlayer:
		animPlayer.play_backwards("text_and_button_animation")
		await animPlayer.animation_finished

func _on_menu_animation_finished() -> void:
	# Запускаем открытие кнопок только если мы в процессе открытия
	if is_opening:
		play_buttons_open_animation()

func _on_off_button_pressed() -> void:
	# Звук уже проигрывается в _on_off_help_press()
	
	# Если анимация уже проигрывается - игнорируем нажатие
	if is_animating:
		return
	
	if is_menu_open:
		# Закрываем меню
		is_animating = true
		
		# Сначала закрываем анимацию кнопок
		await play_buttons_close_animation()
		
		# Затем закрываем меню
		animMenu.play("button_menu_off")
		animShadowScreen.play("shadow_screen_closed_animation")
		await animMenu.animation_finished
		
		is_menu_open = false
		is_animating = false
	else:
		# Открываем меню
		is_animating = true
		is_opening = true
		animMenu.play("button_menu_on")
		animShadowScreen.play("shadow_screen_opened_animation")
		is_menu_open = true
		await animMenu.animation_finished
		play_buttons_open_animation()

func _on_play_button_pressed() -> void:
	# Звук уже проигрывается в _on_button_press()
	SceneLoader.load_scene("res://scenes/loadgame_scene/loadgame_scene.tscn")

func _on_pref_button_pressed() -> void:
	# Звук уже проигрывается в _on_button_press()
	SceneLoader.load_scene("res://scenes/preferences_scene/pref_scene.tscn")

func _on_exit_button_pressed() -> void:
	# Звук уже проигрывается в _on_button_press()
	get_tree().quit()

# Добавьте эти функции, если нужно обработать нажатие на кнопку Help
func _on_help_button_pressed() -> void:
	# Звук уже проигрывается в _on_off_help_press()
	# Добавьте здесь логику для кнопки Help
	print("Help button pressed")
	# SceneLoader.load_scene("res://scenes/help_scene/help_scene.tscn")
