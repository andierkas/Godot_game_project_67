extends Node

const SquadScene = preload("res://scenes/Squad.tscn")
const QuestPanelScene = preload("res://scenes/Gameplay_scene/questdescript.tscn")
const QuestSolveScene = preload("res://scenes/Gameplay_scene/quest_solve.tscn")

@onready var base_spawn = $Base
@onready var questmark = $questmark/Mark

func _ready() -> void:
	print("🏠 Главная сцена загружена")
	
	if questmark:
		questmark.quest_clicked.connect(_on_quest_clicked)
		questmark.quest_ready_clicked.connect(_on_quest_ready_clicked)  # Новый сигнал
	else:
		print("⚠️ questmark не найден!")

# Клик по доступному квесту → открываем панель выбора агентов
func _on_quest_clicked(quest_data: Quest, target_pos: Vector2) -> void:
	print("🎯 Открытие панели выбора агентов")
	
	var panel = QuestPanelScene.instantiate()
	add_child(panel)
	
	panel.show_quest(quest_data, target_pos)
	panel.quest_accepted.connect(_on_quest_accepted)

func _on_quest_accepted(agents: Array, target_pos: Vector2) -> void:
	print("🚀 Создаем отряд! Агентов: ", agents.size())
	
	var squad = SquadScene.instantiate()
	
	if base_spawn:
		squad.position = base_spawn.global_position
	else:
		squad.position = Vector2(400, 300)
	
	add_child(squad)
	
	squad.setup(agents, target_pos)
	squad.squad_arrived.connect(_on_squad_arrived)
	
	for agent in agents:
		agent.current_status = AgentStats.Status.ON_MISSION
	
	if questmark:
		questmark.set_state(QuestMarker.QuestState.IN_PROGRESS)

# Отряд дошел → меняем иконку, но НЕ открываем панель
func _on_squad_arrived(agents: Array) -> void:
	print("🏁 Отряд прибыл!")
	
	for agent in agents:
		agent.current_status = AgentStats.Status.AVAILABLE
	
	if questmark:
		questmark.set_state(QuestMarker.QuestState.READY_TO_SOLVE)
		print("✅ Иконка изменена на 'готов к решению'")
	
	# Панель решения НЕ открываем! Ждем клика игрока.

# Клик по готовому квесту → открываем панель решения
func _on_quest_ready_clicked(quest_data: Quest) -> void:
	print(" Открытие панели решения")
	
	var solve_panel = QuestSolveScene.instantiate()
	add_child(solve_panel)
	
	solve_panel.show_quest(quest_data)  # Передаем данные квеста
	solve_panel.solution_chosen.connect(_on_solution_chosen)

func _on_solution_chosen(solution_id: int) -> void:
	print("✅ Решение выбрано: ", solution_id)
	
	# Здесь логика применения решения (награды, последствия и т.д.)
	
	if questmark:
		questmark.set_state(QuestMarker.QuestState.AVAILABLE)
