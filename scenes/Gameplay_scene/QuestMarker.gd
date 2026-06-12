extends Area2D
class_name QuestMarker

const QuestPanelScene = preload("res://scenes/Gameplay_scene/questdescript.tscn")

const TEXTURE_AVAILABLE = preload("res://QuestMark.png")
const TEXTURE_IN_PROGRESS = preload("res://QuestWait.png")
const TEXTURE_READY = preload("res://QuestReady.png")

enum QuestState {
	AVAILABLE,
	IN_PROGRESS,
	READY_TO_SOLVE
}

@onready var target = $"../Target"
@onready var sprite = $CollisionShape2D/Sprite2D
@export var quest: Quest

var quest_state: QuestState = QuestState.AVAILABLE

# Сигнал для открытия панели выбора агентов
signal quest_clicked(quest_data: Quest, target_pos: Vector2)

# Сигнал для открытия панели решения (когда квест готов)
signal quest_ready_clicked(quest_data: Quest)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_open_quest_panel()

func _open_quest_panel():
	if not quest:
		print("⚠️ Квест не назначен!")
		return
	
	# Проверяем состояние и отправляем нужный сигнал
	match quest_state:
		QuestState.AVAILABLE:
			if not target:
				print("⚠️ Target не найден!")
				return
			print("📍 Позиция Target: ", target.global_position)
			quest_clicked.emit(quest, target.global_position)
		
		QuestState.IN_PROGRESS:
			print("⏳ Квест еще выполняется, отряд в пути...")
			# Ничего не делаем, или можно показать подсказку
		
		QuestState.READY_TO_SOLVE:
			print("✅ Квест готов к решению!")
			quest_ready_clicked.emit(quest)

func set_state(new_state: QuestState) -> void:
	quest_state = new_state
	_update_sprite()

func _update_sprite() -> void:
	if sprite == null:
		print("⚠️ Sprite2D не найден!")
		return

	match quest_state:
		QuestState.AVAILABLE:
			sprite.texture = TEXTURE_AVAILABLE
			print("🔄 Иконка: доступен")
		
		QuestState.IN_PROGRESS:
			sprite.texture = TEXTURE_IN_PROGRESS
			print(" Иконка: в процессе")
		
		QuestState.READY_TO_SOLVE:
			sprite.texture = TEXTURE_READY
			print("🔄 Иконка: готов к решению")
