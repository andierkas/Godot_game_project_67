extends Node

const SquadScene = preload("res://scenes/Squad.tscn")
const QuestPanelScene = preload("res://scenes/Gameplay_scene/questdescript.tscn")
const QuestSolveScene = preload("res://scenes/Gameplay_scene/quest_solve.tscn")

@onready var base_spawn = $Base
@onready var quest_spawner = $QuestSpawner

# Массив активных квестов. Каждый словарь хранит свои данные, чтобы отряды не путались
var _active_quests: Array[Dictionary] = []
var _current_quest_variant: QuestVariant = null

func _ready() -> void:
	print(" Главная сцена загружена")
	
	quest_spawner.quest_spawned.connect(_on_quest_spawned)
	quest_spawner.quest_clicked.connect(_on_quest_clicked)
	quest_spawner.quest_ready_clicked.connect(_on_quest_ready_clicked)

func _on_quest_spawned(quest: Quest, target_pos: Vector2, mark_node: Node) -> void:
	print("📍 Квест заспавнен: ", quest.name, " на позиции: ", target_pos)

func _on_quest_clicked(quest_data: Quest, target_pos: Vector2, mark_node: Node) -> void:
	print(" Открытие панели выбора агентов для квеста: ", quest_data.name)
	
	var panel = QuestPanelScene.instantiate()
	panel.name = "QuestPanel"
	add_child(panel)
	
	panel.show_quest(quest_data, target_pos)
	# Передаем mark_node через bind
	panel.quest_accepted.connect(_on_quest_accepted.bind(mark_node))

func _on_quest_accepted(agents: Array, target_pos: Vector2, mark_node: Node) -> void:
	print(" Создаем отряд! Агентов: ", agents.size())
	
	# Получаем данные квеста из родителя маркера
	var quest_data = null
	var parent_mark = mark_node.get_parent()
	if parent_mark and "quest" in parent_mark:
		quest_data = parent_mark.quest
	
	# Создаем запись об активном квесте
	var quest_record = {
		"mark_node": mark_node,
		"position": target_pos,
		"agents": agents,
		"quest": quest_data
	}
	
	_active_quests.append(quest_record)
	print("✅ Добавлен активный квест. Всего активных: ", _active_quests.size())
	
	var squad = SquadScene.instantiate()
	
	if base_spawn:
		squad.position = base_spawn.global_position
	else:
		squad.position = Vector2(400, 300)
	
	add_child(squad)
	
	squad.setup(agents, target_pos)
	# Передаем mark_node через bind
	squad.squad_arrived.connect(_on_squad_arrived.bind(mark_node))
	
	for agent in agents:
		agent.current_status = AgentStats.Status.ON_MISSION
		print("🟡 Агент ", agent.agent_second_name, " → ON_MISSION")
	
	_refresh_ui()
	
	# Меняем состояние маркера на IN_PROGRESS (2)
	if mark_node and mark_node.has_method("set_state"):
		mark_node.set_state(2)
		print("🔄 Маркер ", mark_node.name, " → IN_PROGRESS")

func _on_squad_arrived(agents: Array, mark_node: Node) -> void:
	print("🏁 Отряд прибыл к квесту!")
	
	# Меняем состояние маркера на READY_TO_SOLVE (3)
	if mark_node and mark_node.has_method("set_state"):
		mark_node.set_state(3)
		print("✅ Маркер ", mark_node.name, " → READY_TO_SOLVE")

func _on_quest_ready_clicked(quest_data: Quest, mark_node: Node) -> void:
	print("🔍 Открытие панели решения")
	
	# Находим квест по маркеру
	var quest_record = _find_quest_by_mark(mark_node)
	if quest_record.is_empty():
		print("⚠️ Не найден активный квест для этого маркера!")
		return
	
	var solve_panel = QuestSolveScene.instantiate()
	add_child(solve_panel)
	
	solve_panel.setup(quest_data, quest_record["agents"])
	# Передаем quest_record через bind
	solve_panel.solution_chosen.connect(_on_solution_chosen.bind(quest_record))

func _on_solution_chosen(variant: QuestVariant, success: bool, quest_record: Dictionary) -> void:
	print("✅ Решение выбрано: ", variant.text)
	print("🎲 Успех: ", success)
	
	_current_quest_variant = variant
	var agents = quest_record["agents"]
	
	if success:
		var rewards = QuestRewardCalculator.calculate_rewards(variant.reward_xp, agents.size())
		PlayerStats.add_xp(rewards.player_xp)
		print("💰 Диспетчер получил ", rewards.player_xp, " XP")
		
		for agent in agents:
			agent.add_xp(rewards.agent_xp_per_person)
	else:
		print("❌ Провал! Применяем последствия...")
		_apply_failure_consequences(variant, agents)
	
	if base_spawn and not agents.is_empty():
		var return_squad = SquadScene.instantiate()
		return_squad.position = quest_record["position"]
		add_child(return_squad)
		
		return_squad.setup(agents, base_spawn.global_position)
		# Передаем quest_record через bind
		return_squad.squad_arrived.connect(_on_return_squad_arrived.bind(quest_record))
	
	# Удаляем квест из активных
	_active_quests.erase(quest_record)
	print("🗑️ Квест удален из активных. Осталось: ", _active_quests.size())

func _apply_failure_consequences(variant: QuestVariant, agents: Array) -> void:
	var squad_size = agents.size()
	
	if variant.failure_damage > 0:
		PlayerStats.take_damage(variant.failure_damage)
		print("🏙️ Город получил ", variant.failure_damage, " урона!")
	
	if variant.failure_text != "":
		print("📝 ", variant.failure_text)
	
	var roll = randf()
	
	if roll < 0.2:
		print("🍀 Удача! Агенты не пострадали.")
		return
	
	print("🩸 Агенты получили ранения...")
	
	var wounded_count = 0
	
	if squad_size >= 1:
		if _try_wound_random_agent(agents):
			wounded_count += 1
	
	if squad_size >= 4:
		var second_roll = randf()
		if second_roll < 0.5:
			if _try_wound_random_agent(agents):
				wounded_count += 1
				print("🩸 Второй агент тоже ранен!")
	
	print("📊 Итого ранено агентов: ", wounded_count)
	_refresh_ui()

func _try_wound_random_agent(agents: Array) -> bool:
	var healthy_agents = []
	for agent in agents:
		if not agent.is_wounded:
			healthy_agents.append(agent)
	
	if healthy_agents.is_empty():
		return false
	
	var victim = healthy_agents[randi() % healthy_agents.size()]
	
	if victim.is_wounded:
		print("💀 Агент ", victim.agent_second_name, " погиб!")
		var index = PartyBox.party.find(victim)
		if index != -1:
			PartyBox.remove_agent(index)
	else:
		victim.is_wounded = true
		print("🩸 Агент ", victim.agent_second_name, " ранен!")
	
	return true

func _on_return_squad_arrived(agents: Array, quest_record: Dictionary) -> void:
	print("🏠 Отряд вернулся на базу! Агентов: ", agents.size())
	
	for agent in agents:
		agent.current_status = AgentStats.Status.RESTING
	
	_refresh_ui()
	
	var rest_duration = randf_range(10.0, 15.0)
	print("⏱️ Таймер отдыха: ", rest_duration, " секунд")
	
	await get_tree().create_timer(rest_duration).timeout
	
	for agent in agents:
		agent.current_status = AgentStats.Status.AVAILABLE
	
	_refresh_ui()
	
	# Возвращаем маркер в состояние EMPTY
	var mark_node = quest_record["mark_node"]
	if mark_node and mark_node.has_method("set_state"):
		mark_node.set_state(0)
		
		var parent_mark = mark_node.get_parent()
		if parent_mark and "quest" in parent_mark:
			parent_mark.quest = null
		
		print("🔄 Маркер ", mark_node.name, " → EMPTY")

func _find_quest_by_mark(mark_node: Node) -> Dictionary:
	for quest_record in _active_quests:
		if quest_record["mark_node"] == mark_node:
			return quest_record
	return {}

func _refresh_ui() -> void:
	var grid = get_node_or_null("Panel/GridContainer")
	if grid and grid.has_method("refresh_all_slots"):
		grid.refresh_all_slots()
		print("🔄 UI обновлен")
