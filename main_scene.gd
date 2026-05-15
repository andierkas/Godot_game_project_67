extends Control

var selected_mode = null

func _ready():
	# Кнопки выбора режима
	$HBoxContainer/TextureButton.pressed.connect(_on_easy)
	$HBoxContainer/TextureButton4.pressed.connect(_on_medium)
	$HBoxContainer/TextureButton3.pressed.connect(_on_hard)
	
	# ✅ ВОТ ЭТИ ДВЕ СТРОЧКИ НУЖНО РАСКОММЕНТИРОВАТЬ (они подключают кнопки):
	$Button.pressed.connect(_on_confirm)
	$Button2.pressed.connect(_on_confirm)
	
	# Блокируем кнопки подтверждения
	$Button.disabled = true
	$Button2.disabled = true
	$Button.modulate = Color(0.5, 0.5, 0.5)
	$Button2.modulate = Color(0.5, 0.5, 0.5)
	
	print("✅ Выберите режим!")

func _on_easy():
	selected_mode = "easy"
	print("🎮 ЛЁГКИЙ режим")
	activate_buttons()

func _on_medium():
	selected_mode = "medium"
	print("🎮 СРЕДНИЙ режим")
	activate_buttons()

func _on_hard():
	selected_mode = "hard"
	print("🎮 СЛОЖНЫЙ режим")
	activate_buttons()

func activate_buttons():
	$Button.disabled = false
	$Button2.disabled = false
	$Button.modulate = Color(1, 1, 1)
	$Button2.modulate = Color(1, 1, 1)
	print("🔓 Кнопки подтверждения разблокированы!")

func _on_confirm():
	print("🔴 Кнопка подтверждения нажата!")
	
	if selected_mode == null:
		print("⚠️ Сначала выберите режим!")
		return
	
	print("✅ Переход на сцену!")
	get_tree().change_scene_to_file("res://playfile2.tscn")
