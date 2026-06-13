extends Node

const SquadScene = preload("res://scenes/Squad.tscn")
const QuestPanelScene = preload("res://scenes/Gameplay_scene/questdescript.tscn")
const QuestSolveScene = preload("res://scenes/Gameplay_scene/quest_solve.tscn")

@onready var base_spawn = $Base
@onready var questmark = $questmark/Mark

var _current_quest_agents: Array = []
var _current_quest_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	print("🏠 Главная сцена загружена")
	
	if questmark:
		questmark.quest_clicked.connect(_on_quest_clicked)
		questmark.quest_ready_clicked.connect(_on_quest_ready_clicked)
	else:
		print("⚠️ questmark не найден!")

func _on_quest_clicked(quest_data: Quest, target_pos: Vector2) -> void:
	print("🎯 Открытие панели выбора агентов")
	
	var panel = QuestPanelScene.instantiate()
	add_child(panel)
	
	panel.show_quest(quest_data, target_pos)
	panel.quest_accepted.connect(_on_quest_accepted)

func _on_quest_accepted(agents: Array, target_pos: Vector2) -> void:
	print("🚀 Создаем отряд! Агентов: ", agents.size())
	
	_current_quest_agents = agents
	_current_quest_position = target_pos
	print("📍 Сохранена позиция квеста: ", _current_quest_position)
	
	var squad = SquadScene.instantiate()
	
	if base_spawn:
		squad.position = base_spawn.global_position
	else:
		squad.position = Vector2(400, 300)
	
	add_child(squad)
	
	squad.setup(agents, target_pos)
	squad.squad_arrived.connect(_on_squad_arrived)
	
	# Меняем статус на ON_MISSION
	for agent in agents:
		agent.current_status = AgentStats.Status.ON_MISSION
		print("🟡 Агент ", agent.agent_second_name, " → ON_MISSION")
	
	# ⬇️ ОБНОВЛЯЕМ UI ПОСЛЕ СМЕНЫ СТАТУСА
	_refresh_ui()
	
	if questmark:
		questmark.set_state(QuestMarker.QuestState.IN_PROGRESS)

func _on_squad_arrived(agents: Array) -> void:
	print("🏁 Отряд прибыл к квесту!")
	
	# НЕ меняем статус! Агенты остаются ON_MISSION
	for agent in agents:
		print("🟡 Агент ", agent.agent_second_name, " ждёт решения (статус: ", agent.current_status, ")")
	
	if questmark:
		questmark.set_state(QuestMarker.QuestState.READY_TO_SOLVE)
		print("✅ Иконка изменена на 'готов к решению'")

func _on_quest_ready_clicked(quest_data: Quest) -> void:
	print("🔍 Открытие панели решения")
	print("🔍 Сохранённых агентов: ", _current_quest_agents.size())
	print("📍 Позиция квеста: ", _current_quest_position)
	
	var solve_panel = QuestSolveScene.instantiate()
	add_child(solve_panel)
	
	solve_panel.setup(quest_data, _current_quest_agents)
	solve_panel.solution_chosen.connect(_on_solution_chosen)

func _on_solution_chosen(variant: QuestVariant, success: bool) -> void:
	print("✅ Решение выбрано: ", variant.text)
	print("🎲 Успех: ", success)
	
	if success:
		print("💰 Награда: ", variant.reward_xp, " XP")
	else:
		print("❌ Провал!")
	
	if base_spawn and not _current_quest_agents.is_empty():
		print("🏠 Создаём отряд для возврата на базу")
		print("📍 Позиция квеста: ", _current_quest_position)
		print("📍 Позиция базы: ", base_spawn.global_position)
		print("👥 Агентов: ", _current_quest_agents.size())
		
		var return_squad = SquadScene.instantiate()
		return_squad.position = _current_quest_position
		add_child(return_squad)
		
		print("🚀 Отряд создан, позиция: ", return_squad.global_position)
		
		return_squad.setup(_current_quest_agents, base_spawn.global_position)
		return_squad.squad_arrived.connect(_on_return_squad_arrived)
		
		print("✅ Отряд настроен и должен идти на базу")
	else:
		print("⚠️ Не создаём отряд. База: ", base_spawn != null, " Агенты: ", _current_quest_agents.size())
	
	_current_quest_agents = []
	_current_quest_position = Vector2.ZERO
	
	if questmark:
		questmark.set_state(QuestMarker.QuestState.AVAILABLE)

func _on_return_squad_arrived(agents: Array) -> void:
	print("🏠 Отряд вернулся на базу! Агентов: ", agents.size())
	
	# Переводим агентов в статус RESTING
	for agent in agents:
		agent.current_status = AgentStats.Status.RESTING
		print("😴 Агент ", agent.agent_second_name, " уходит на отдых")
	
	# ⬇️ ОБНОВЛЯЕМ UI ПОСЛЕ СМЕНЫ СТАТУСА НА RESTING
	_refresh_ui()
	
	# Запускаем таймер отдыха (10-15 секунд)
	var rest_duration = randf_range(10.0, 15.0)
	print("⏱️ Таймер отдыха: ", rest_duration, " секунд")
	
	await get_tree().create_timer(rest_duration).timeout
	
	# ТОЛЬКО ЗДЕСЬ меняем на AVAILABLE после отдыха
	for agent in agents:
		agent.current_status = AgentStats.Status.AVAILABLE
		print("✅ Агент ", agent.agent_second_name, " снова доступен")
	
	# ⬇️ ОБНОВЛЯЕМ UI ПОСЛЕ ОКОНЧАНИЯ ОТДЫХА
	_refresh_ui()

# ⬇️ УНИВЕРСАЛЬНАЯ ФУНКЦИЯ ДЛЯ ОБНОВЛЕНИЯ UI
func _refresh_ui() -> void:
	var grid = get_node_or_null("Panel/GridContainer")
	if grid and grid.has_method("refresh_all_slots"):
		grid.refresh_all_slots()
		print("🔄 UI обновлен")
	else:
		print("⚠️ GridContainer не найден по пути Panel/GridContainer")
