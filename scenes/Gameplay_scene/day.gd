extends Node

const SquadScene = preload("res://scenes/Squad.tscn")
const QuestPanelScene = preload("res://scenes/Gameplay_scene/questdescript.tscn")
const QuestSolveScene = preload("res://scenes/Gameplay_scene/quest_solve.tscn")

@onready var base_spawn = $Base
@onready var questmark = $questmark/Mark

var _current_quest_agents: Array = []
var _current_quest_position: Vector2 = Vector2.ZERO
var _current_quest_variant: QuestVariant = null
var _current_quest: Quest = null  # ️ Сохраняем ссылку на квест

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
	
	for agent in agents:
		agent.current_status = AgentStats.Status.ON_MISSION
		print("🟡 Агент ", agent.agent_second_name, " → ON_MISSION")
	
	_refresh_ui()
	
	if questmark:
		questmark.set_state(QuestMarker.QuestState.IN_PROGRESS)

func _on_squad_arrived(agents: Array) -> void:
	print("🏁 Отряд прибыл к квесту!")
	
	for agent in agents:
		print("🟡 Агент ", agent.agent_second_name, " ждёт решения (статус: ", agent.current_status, ")")
	
	if questmark:
		questmark.set_state(QuestMarker.QuestState.READY_TO_SOLVE)
		print("✅ Иконка изменена на 'готов к решению'")

func _on_quest_ready_clicked(quest_data: Quest) -> void:
	print(" Открытие панели решения")
	print("🔍 Сохранённых агентов: ", _current_quest_agents.size())
	print("📍 Позиция квеста: ", _current_quest_position)
	
	_current_quest = quest_data  # ⬅️ Сохраняем квест
	
	var solve_panel = QuestSolveScene.instantiate()
	add_child(solve_panel)
	
	solve_panel.setup(quest_data, _current_quest_agents)
	solve_panel.solution_chosen.connect(_on_solution_chosen)

func _on_solution_chosen(variant: QuestVariant, success: bool) -> void:
	print("✅ Решение выбрано: ", variant.text)
	print("🎲 Успех: ", success)
	
	_current_quest_variant = variant
	
	if success:
		# ⬇️ НАЧИСЛЕНИЕ НАГРАД
		print("💰 Начисляем награды...")
		
		# 1. Игрок (диспетчер) получает награду из Quest.gd
		if _current_quest and _current_quest.player_reward_xp > 0:
			var player_xp = QuestRewardCalculator.calculate_variable_xp(_current_quest.player_reward_xp)
			PlayerStats.add_xp(player_xp)
			print("️ Игрок получил ", player_xp, " XP")
		
		# 2. Агенты получают награду из QuestVariant.gd
		if not _current_quest_agents.is_empty():
			var agent_xp = QuestRewardCalculator.calculate_variable_xp(variant.reward_xp)
			var multiplier = QuestRewardCalculator.get_squad_multiplier(_current_quest_agents.size())
			var total_agent_xp = int(agent_xp * multiplier)
			var xp_per_agent = int(total_agent_xp / _current_quest_agents.size())
			
			print("👥 Агенты получают: база=", agent_xp, " множитель=", multiplier, " на каждого=", xp_per_agent)
			
			for agent in _current_quest_agents:
				agent.add_xp(xp_per_agent)
	else:
		print("❌ Провал! Применяем последствия...")
		_apply_failure_consequences(variant)
	
	if base_spawn and not _current_quest_agents.is_empty():
		print("🏠 Создаём отряд для возврата на базу")
		print(" Позиция квеста: ", _current_quest_position)
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
	_current_quest = null
	
	if questmark:
		questmark.set_state(QuestMarker.QuestState.AVAILABLE)

func _apply_failure_consequences(variant: QuestVariant) -> void:
	var squad_size = _current_quest_agents.size()
	
	# 1. Игрок ВСЕГДА получает урон при провале
	if variant.failure_damage > 0:
		PlayerStats.take_damage(variant.failure_damage)
		print("️ Город получил ", variant.failure_damage, " урона!")
	
	if variant.failure_text != "":
		print("📝 ", variant.failure_text)
	
	# 2. Определяем судьбу агентов
	var roll = randf()
	
	if roll < 0.2:
		print("🍀 Удача! Агенты не пострадали, пострадал только город.")
		return
	
	print("🩸 Агенты получили ранения...")
	
	var wounded_count = 0
	
	if squad_size >= 1:
		if _try_wound_random_agent():
			wounded_count += 1
	
	if squad_size >= 4:
		var second_roll = randf()
		if second_roll < 0.5:
			if _try_wound_random_agent():
				wounded_count += 1
				print("🩸 Второй агент тоже ранен!")
		else:
			print(" Второй агент избежал ранения (шанс 50%)")
	
	print("📊 Итого ранено агентов: ", wounded_count)
	
	_refresh_ui()

func _try_wound_random_agent() -> bool:
	var healthy_agents = []
	for agent in _current_quest_agents:
		if not agent.is_wounded:
			healthy_agents.append(agent)
	
	if healthy_agents.is_empty():
		print("⚠️ Все агенты в отряде уже ранены!")
		return false
	
	var victim = healthy_agents[randi() % healthy_agents.size()]
	
	if victim.is_wounded:
		print("💀 Агент ", victim.agent_second_name, " получил второе ранение и погиб!")
		var index = PartyBox.party.find(victim)
		if index != -1:
			PartyBox.remove_agent(index)
			print("🗑️ Агент ", victim.agent_second_name, " удалён из отряда")
	else:
		victim.is_wounded = true
		print(" Агент ", victim.agent_second_name, " ранен!")
	
	return true

func _on_return_squad_arrived(agents: Array) -> void:
	print("🏠 Отряд вернулся на базу! Агентов: ", agents.size())
	
	for agent in agents:
		agent.current_status = AgentStats.Status.RESTING
		print("😴 Агент ", agent.agent_second_name, " уходит на отдых")
	
	_refresh_ui()
	
	var rest_duration = randf_range(10.0, 15.0)
	print("⏱️ Таймер отдыха: ", rest_duration, " секунд")
	
	await get_tree().create_timer(rest_duration).timeout
	
	for agent in agents:
		agent.current_status = AgentStats.Status.AVAILABLE
		print("✅ Агент ", agent.agent_second_name, " снова доступен")
	
	_refresh_ui()

func _refresh_ui() -> void:
	var grid = get_node_or_null("Panel/GridContainer")
	if grid and grid.has_method("refresh_all_slots"):
		grid.refresh_all_slots()
		print("🔄 UI обновлен")
	else:
		print("⚠️ GridContainer не найден по пути Panel/GridContainer")
