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

func show_quest(quest_data: Quest, target_pos: Vector2):  # ← Добавили параметр
	quest = quest_data
	quest_target_position = target_pos  # ← Берём из узла, а не из ресурса
	namequest.text = quest.name
	quest_desc.text = quest.description
	sprite.texture = quest.slide
	print("📍 Цель из узла Target: ", quest_target_position)
	show()

func _on_button_pressed() -> void:
	print("❌ Кнопка Close нажата")
	queue_free()

func _on_next_pressed() -> void:
	print("🟡 Кнопка Next нажата!")
	
	# Собираем агентов из слотов типа "target"
	var selected_agents = []
	
	for slot in agents_grid.get_children():
		print("   Проверяем слот: ", slot.name, " тип: ", slot.container_type, " агент: ", slot.agent)
		
		# Проверяем что это слот назначения и там есть агент
		if slot.container_type == "target" and slot.agent != null:
			# Проверяем что это не заглушка
			if not slot.agent.is_dummy:
				selected_agents.append(slot.agent)
				print("   ✅ Добавлен агент: ", slot.agent.agent_first_name)
			else:
				print("   ⚠️ Пропущена заглушка")
	
	print("📦 Всего выбрано агентов: ", selected_agents.size())
	
	# Проверяем что выбрали хотя бы одного агента
	if selected_agents.size() == 0:
		print("⚠️ Нужно выбрать хотя бы одного агента!")
		return
	
	# Отправляем сигнал с агентами и целью
	print("📡 Отправляем сигнал quest_accepted...")
	quest_accepted.emit(selected_agents, quest_target_position)
	print("✅ Сигнал отправлен!")
	
	# Закрываем панель
	queue_free()
