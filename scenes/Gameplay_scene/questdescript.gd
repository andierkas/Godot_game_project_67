extends Panel

@onready var sprite = $spritequest
@onready var namequest = $NameQuest
@onready var quest_desc = $descript
@onready var agents_grid = $GridContainer  # Контейнер со слотами

# Сигнал для главной сцены
signal quest_accepted(agents: Array, target_pos: Vector2)

@export var quest: Quest  # Данные квеста
var quest_target_position: Vector2  # Куда идти отряду

func _ready() -> void:
	print("🟢 Панель квеста загружена")

func show_quest(quest_data: Quest, target_pos: Vector2):
	quest = quest_data
	quest_target_position = target_pos
	namequest.text = quest.name
	quest_desc.text = quest.description
	sprite.texture = quest.slide
	print(" Цель из узла Target: ", quest_target_position)
	show()

func _on_button_pressed() -> void:
	print("❌ Кнопка Close нажата")
	queue_free()

func _on_next_pressed() -> void:
	print("🟡 Кнопка Next нажата!")
	
	var selected_agents = []
	var unavailable_agents = []
	
	for slot in agents_grid.get_children():
		# Пропускаем пустые слоты
		if slot.agent == null:
			continue
		
		#  ГЛАВНАЯ ПРОВЕРКА: доступен ли агент?
		if slot.agent.current_status != AgentStats.Status.AVAILABLE:
			unavailable_agents.append(slot.agent.agent_second_name)
			print("   ⛔ Пропущен агент (статус: ", slot.agent.current_status, "): ", slot.agent.agent_second_name)
			continue
		
		# Проверяем что это не заглушка
		if slot.agent.is_dummy:
			print("   ⚠️ Пропущена заглушка")
			continue
		
		selected_agents.append(slot.agent)
		print("   ✅ Добавлен агент: ", slot.agent.agent_first_name)
	
	# Предупреждение если пытались выбрать недоступных
	if not unavailable_agents.is_empty():
		print("⚠️ Агенты недоступны для выбора (отдыхают или в пути): ", unavailable_agents)
	
	print("📦 Всего выбрано доступных агентов: ", selected_agents.size())
	
	# Проверяем что выбрали хотя бы одного ДОСТУПНОГО агента
	if selected_agents.size() == 0:
		print("⚠️ Нужно выбрать хотя бы одного ДОСТУПНОГО агента!")
		# Здесь можно добавить вывод сообщения на экран, если есть Label для ошибок
		return
	
	# Отправляем сигнал с агентами и целью
	print("📡 Отправляем сигнал quest_accepted...")
	quest_accepted.emit(selected_agents, quest_target_position)
	print("✅ Сигнал отправлен!")
	
	# Закрываем панель
	queue_free()
