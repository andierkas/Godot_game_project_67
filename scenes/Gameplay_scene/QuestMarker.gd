extends Area2D
class_name QuestMarker

const QuestPanelScene = preload("res://scenes/Gameplay_scene/questdescript.tscn")

const TEXTURE_AVAILABLE = preload("res://QuestMark.png")
const TEXTURE_IN_PROGRESS = preload("res://QuestWait.png")
const TEXTURE_READY = preload("res://QuestReady.png")

enum QuestState {
	EMPTY,
	AVAILABLE,
	IN_PROGRESS,
	READY_TO_SOLVE
}

@onready var target = $"../Target"
@onready var sprite = $CollisionShape2D/Sprite2D
@export var quest: Quest  # ⬅️ ВЕРНУЛИ

var quest_state: QuestState = QuestState.EMPTY

signal quest_clicked(quest_data: Quest, target_pos: Vector2, source_node: Node)
signal quest_ready_clicked(quest_data: Quest, source_node: Node)

func _ready() -> void:
	quest_state = QuestState.EMPTY
	visible = false
	_update_sprite()

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_open_quest_panel()

func _open_quest_panel():
	# ⬇️ Используем свой quest (который установил QuestSpawner)
	if not quest:
		print("⚠️ Квест не назначен!")
		return
	
	var target_pos = target.global_position if target else global_position
	
	match quest_state:
		QuestState.AVAILABLE:
			print("📍 Позиция Target: ", target_pos)
			quest_clicked.emit(quest, target_pos, self)
		
		QuestState.IN_PROGRESS:
			print("⏳ Квест еще выполняется, отряд в пути...")
		
		QuestState.READY_TO_SOLVE:
			print("✅ Квест готов к решению!")
			quest_ready_clicked.emit(quest, self)
		
		QuestState.EMPTY:
			print("⚠️ На этом маркере нет квеста")

func set_state(new_state: QuestState) -> void:
	quest_state = new_state
	_update_sprite()
	_update_visibility()

func _update_sprite() -> void:
	if sprite == null:
		return

	match quest_state:
		QuestState.EMPTY:
			pass
		QuestState.AVAILABLE:
			sprite.texture = TEXTURE_AVAILABLE
		QuestState.IN_PROGRESS:
			sprite.texture = TEXTURE_IN_PROGRESS
		QuestState.READY_TO_SOLVE:
			sprite.texture = TEXTURE_READY

func _update_visibility() -> void:
	visible = quest_state != QuestState.EMPTY
