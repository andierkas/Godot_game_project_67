extends Area2D

@onready var target = $"../Target"
@export var quest: Quest

# Сигнал для главной сцены
signal quest_clicked(quest_data: Quest, target_pos: Vector2)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_open_quest_panel()

func _open_quest_panel():
	if not quest:
		print("⚠️ Квест не назначен!")
		return
	if not target:
		print("⚠️ Target не найден!")
		return

	print(" Позиция Target: ", target.global_position)
	
	# Просто отправляем сигнал главной сцене, пусть она сама открывает панель
	quest_clicked.emit(quest, target.global_position)
