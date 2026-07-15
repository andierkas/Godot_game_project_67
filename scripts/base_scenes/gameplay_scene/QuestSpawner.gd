extends Node
class_name QuestSpawner

# Сигналы — все передают ссылку на mark_node
signal quest_spawned(quest: Quest, target_pos: Vector2, mark_node: Node)
signal quest_clicked(quest_data: Quest, target_pos: Vector2, mark_node: Node)
signal quest_ready_clicked(quest_data: Quest, mark_node: Node)

@export var available_quests: Array[Quest] = []
@export var spawn_interval: float = 15.0

@onready var quest_spawns: Node = $QuestSpawns

func _ready() -> void:
	print("🎯 QuestSpawner загружен")
	
	# Подключаем сигналы всех маркеров
	for mark in quest_spawns.get_children():
		var mark_node = mark.get_node_or_null("Mark")
		if mark_node:
			if mark_node.has_signal("quest_clicked"):
				mark_node.quest_clicked.connect(_on_mark_quest_clicked)
			if mark_node.has_signal("quest_ready_clicked"):
				mark_node.quest_ready_clicked.connect(_on_mark_quest_ready_clicked)
	
	_start_quest_spawner()

func _start_quest_spawner() -> void:
	while true:
		await get_tree().create_timer(spawn_interval).timeout
		_activate_random_quest()

func _activate_random_quest() -> void:
	if available_quests.is_empty():
		print("⚠️ Список доступных квестов пуст!")
		return

	# Ищем маркеры в состоянии EMPTY (0)
	var empty_marks = []
	for mark in quest_spawns.get_children():
		var new_mark_node = mark.get_node_or_null("Mark")
		if new_mark_node and new_mark_node.has_method("set_state"):
			if new_mark_node.quest_state == 0:
				empty_marks.append(mark)

	if empty_marks.is_empty():
		print("🚫 Нет свободных маркеров!")
		return

	var target_mark = empty_marks.pick_random()
	var quest_data = available_quests.pick_random()
	var mark_node = target_mark.get_node_or_null("Mark")
	
	if not mark_node:
		print("⚠️ Mark не найден в ", target_mark.name)
		return

	# ⬇️ УСТАНОВКА КВЕСТА НА mark_node (дочерний узел Mark), а не на родителя!
	if "quest" in mark_node:
		mark_node.quest = quest_data
		print("✅ Квест установлен на Mark: ", quest_data.name)
	else:
		print("⚠️ У узла Mark нет переменной 'quest'!")
		return

	# Меняем состояние на AVAILABLE (1)
	if mark_node.has_method("set_state"):
		mark_node.set_state(1)

	print("✅ Квест '", quest_data.name, "' активирован на маркере: ", target_mark.name)
	
	# Передаём позицию Target и ссылку на mark_node
	var target_node = target_mark.get_node_or_null("Target")
	if target_node:
		quest_spawned.emit(quest_data, target_node.global_position, mark_node)

func _on_mark_quest_clicked(quest_data: Quest, target_pos: Vector2, source_node: Node) -> void:
	print("📡 QuestSpawner получил quest_clicked: ", quest_data.name if quest_data else "NULL")
	quest_clicked.emit(quest_data, target_pos, source_node)

func _on_mark_quest_ready_clicked(quest_data: Quest, source_node: Node) -> void:
	print("📡 QuestSpawner получил quest_ready_clicked: ", quest_data.name if quest_data else "NULL")
	quest_ready_clicked.emit(quest_data, source_node)

# ⬇️ Метод для очистки квеста у маркера (вызывается из day.gd при возврате отряда)
func clear_quest_on_mark(mark_node: Node) -> void:
	if mark_node and "quest" in mark_node:
		mark_node.quest = null
		print("🧹 Квест очищен на маркере")
