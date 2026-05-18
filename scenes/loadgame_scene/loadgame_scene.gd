extends Control

var selected_mode = null

func _ready():
	# Кнопки выбора режима
	$HBoxContainer/TextureButton.pressed.connect(_first_save)
	$HBoxContainer/TextureButton4.pressed.connect(_second_save)
	$HBoxContainer/TextureButton3.pressed.connect(_third_save)
	
	# Блокируем кнопки подтверждения
	$Button.disabled = true
	$Button2.disabled = true
	$Button.modulate = Color(0.5, 0.5, 0.5)
	$Button2.modulate = Color(0.5, 0.5, 0.5)

func _first_save():
	activate_buttons()

func _second_save():
	activate_buttons()

func _third_save():
	activate_buttons()

func activate_buttons():
	$Button.disabled = false
	$Button2.disabled = false
	$Button.modulate = Color(1, 1, 1)
	$Button2.modulate = Color(1, 1, 1)

func _on_button_pressed() -> void:
	SceneLoader.load_scene("res://scenes/agents_generator_scene/agents_generator.tscn")
