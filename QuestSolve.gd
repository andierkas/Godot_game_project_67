extends TextureRect

signal solution_chosen(variant: QuestVariant, success: bool)

@onready var namequest = $NameQuest
@onready var quest_desc = $descript
@onready var sprite = $spritequest
@onready var options_container = $OptionsContainer
@onready var variant_pentagon: Polygon2D = $PentagonView/VariantPentagon
@onready var agent_pentagon: Polygon2D = $PentagonView/AgentPentagon
@onready var success_label: Label = $PentagonView/SuccessLabel
@onready var pentagon_view = $PentagonView
@onready var template_button = $ButtonPrev  # Шаблон кнопки

@export var quest: Quest
var agents: Array
var selected_variant: QuestVariant
var variant_buttons: Array = []

func _ready() -> void:
	print("🟢 Панель решения загружена")
	pentagon_view.visible = false
	template_button.visible = false  # Скрываем шаблон
	if quest:
		show_quest(quest)

func setup(quest_data: Quest, squad_agents: Array):
	quest = quest_data
	agents = squad_agents
	show_quest(quest)

func show_quest(quest_data: Quest):
	quest = quest_data
	if quest:
		namequest.text = quest.name
		quest_desc.text = quest.description
		sprite.texture = quest.slide
		
		# Очищаем старые кнопки
		for child in options_container.get_children():
			child.queue_free()
		
		variant_buttons.clear()
		
		# Сохраняем размер шаблона
		var template_size = template_button.size
		print("🔍 Размер шаблона: ", template_size)
		
		for variant in quest.variants:
			var new_button = template_button.duplicate()
			new_button.visible = true
			
			# Копируем текстуры
			new_button.texture_normal = template_button.texture_normal
			new_button.texture_pressed = template_button.texture_pressed
			new_button.texture_hover = template_button.texture_hover
			
			# Устанавливаем размер
			new_button.size = template_size
			if new_button.size.x == 0 or new_button.size.y == 0:
				new_button.size = Vector2(200, 50)
			
			new_button.custom_minimum_size = new_button.size
			
			# ✅ НАСТРАИВАЕМ ТЕКСТ ПРАВИЛЬНО
			var label = new_button.get_node_or_null("Label")
			if label:
				label.text = variant.text
				
				# ✅ Центрируем текст
				label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				
				# ✅ Растягиваем Label на всю кнопку
				label.size = new_button.size
				label.position = Vector2.ZERO
				
				# ✅ ИЛИ используем anchors для растягивания
				label.anchor_left = 0.0
				label.anchor_top = 0.0
				label.anchor_right = 1.0
				label.anchor_bottom = 1.0
				label.offset_left = 0
				label.offset_top = 0
				label.offset_right = 0
				label.offset_bottom = 0
			
			new_button.pressed.connect(_on_variant_pressed.bind(variant))
			options_container.add_child(new_button)
			variant_buttons.append(new_button)
			
			print("🔍 Кнопка создана, размер: ", new_button.size)
		
		show()

func _on_variant_pressed(variant: QuestVariant) -> void:
	selected_variant = variant
	
	print("🔍 Выбран вариант: ", variant.text)
	print("🔍 Статы варианта: сила=", variant.strenght, " харизма=", variant.harisma, " выносливость=", variant.endurance, " интеллект=", variant.intellect, " ловкость=", variant.agility)
	print("🔍 Количество агентов: ", agents.size())
	
	if agents.is_empty():
		print("⚠️ ВНИМАНИЕ: АГЕНТЫ ПУСТЫЕ! Шанс будет 0%, потому что некому выполнять квест.")
	else:
		for agent in agents:
			print("🔍 Агент: ", agent.agent_second_name, " | сила=", agent.strenght, " харизма=", agent.harisma)
	
	options_container.visible = false
	pentagon_view.visible = true
	
	_draw_pentagons()
	_update_success_rate()

# ⬇️ ЭТА ФУНКЦИЯ ВЫЗЫВАЕТСЯ ПРИ НАЖАТИИ КНОПКИ CONFIRM
func _on_confirm_button_pressed() -> void:
	if not selected_variant:
		print("⚠️ Вариант не выбран!")
		return
		
	var squad_stats = _calculate_squad_stats(agents)
	var rate = _get_success_rate(squad_stats, selected_variant)
	var success = randf() <= rate
	
	print("✅ Решение подтверждено: ", selected_variant.text)
	print("🎲 Шанс: ", int(rate * 100), "% | Результат: ", success)
	
	solution_chosen.emit(selected_variant, success)
	queue_free()

func _draw_pentagons():
	if not quest or not selected_variant:
		print("⚠️ Квест или вариант не выбран, пятиугольники не рисуем.")
		return

	if variant_pentagon == null or agent_pentagon == null:
		print("❌ ОШИБКА: Polygon2D не найдены! Проверь имена узлов в сцене quest_solve.tscn")
		return

	var variant_stats = {
		"strenght": selected_variant.strenght,
		"harisma": selected_variant.harisma,
		"endurance": selected_variant.endurance,
		"intellect": selected_variant.intellect,
		"agility": selected_variant.agility
	}
	variant_pentagon.polygon = _generate_pentagon_vertices(variant_stats)

	var squad_stats = _calculate_squad_stats(agents)
	agent_pentagon.polygon = _generate_pentagon_vertices(squad_stats)
	
	print("✅ Пятиугольники нарисованы. Вершин: ", variant_pentagon.polygon.size())

func _update_success_rate():
	if not selected_variant:
		return
	var squad_stats = _calculate_squad_stats(agents)
	var rate = _get_success_rate(squad_stats, selected_variant)
	success_label.text = "Шанс успеха: %d%%" % int(rate * 100)
	print("🎲 Итоговый шанс успеха: ", int(rate * 100), "%")

func _calculate_squad_stats(agents_array: Array) -> Dictionary:
	var stats = {"strenght": 0, "harisma": 0, "endurance": 0, "intellect": 0, "agility": 0}
	
	for agent in agents_array:
		stats.strenght += agent.strenght
		stats.harisma += agent.harisma
		stats.endurance += agent.endurance
		stats.intellect += agent.intellect
		stats.agility += agent.agility
		
	for key in stats:
		stats[key] = mini(stats[key], 10)
		
	return stats

func _get_success_rate(squad_stats: Dictionary, variant: QuestVariant) -> float:
	var total_required = 0
	var total_covered = 0

	var stats_pairs = [
		[squad_stats.strenght, variant.strenght],
		[squad_stats.harisma, variant.harisma],
		[squad_stats.endurance, variant.endurance],
		[squad_stats.intellect, variant.intellect],
		[squad_stats.agility, variant.agility]
	]

	for pair in stats_pairs:
		total_required += pair[1]
		total_covered += mini(pair[0], pair[1])

	if total_required == 0:
		return 1.0

	return clamp(total_covered / float(total_required), 0.0, 1.0)

func _generate_pentagon_vertices(stats: Dictionary) -> PackedVector2Array:
	var y_3 = 0 + stats.agility * 7
	var x_3 = 0 + (64 * float(stats.agility * 7) / 100)
	var third_point = Vector2(x_3, y_3)
	
	var y_4 = 0 + stats.endurance * 7
	var x_4 = 0 - (64 * float(stats.endurance * 7) / 100)
	var four_point = Vector2(x_4, y_4)
	
	return PackedVector2Array([
		Vector2(0 - stats.strenght * 7, 0),
		Vector2(0, 0 - stats.intellect * 7),
		Vector2(0 + stats.harisma * 7, 0),
		third_point,
		four_point
	])
