extends Panel

signal solution_chosen(variant: QuestVariant, success: bool)

@onready var namequest = $NameQuest
@onready var quest_desc = $descript
@onready var sprite = $spritequest
@onready var options_container = $OptionsContainer
@onready var variant_pentagon: Polygon2D = $VariantPentagon
@onready var agent_pentagon: Polygon2D = $AgentPentagon
@onready var success_label: Label = $SuccessLabel
@onready var pentagon_view = $PentagonView

@export var quest: Quest
var agents: Array
var selected_variant: QuestVariant

func _ready() -> void:
	print("🟢 Панель решения загружена")
	pentagon_view.visible = false
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
		
		for child in options_container.get_children():
			child.queue_free()
		
		for variant in quest.variants:
			var button = Button.new()
			button.text = variant.text
			button.pressed.connect(_on_variant_pressed.bind(variant))
			options_container.add_child(button)
	
	show()

func _on_variant_pressed(variant: QuestVariant) -> void:
	selected_variant = variant
	
	options_container.visible = false
	pentagon_view.visible = true
	
	_draw_pentagons()
	_update_success_rate()

func _on_confirm_pressed() -> void:
	if not selected_variant:
		return
		
	var squad_stats = _calculate_squad_stats(agents)
	var success = randf() <= _get_success_rate(squad_stats, selected_variant)
	
	solution_chosen.emit(selected_variant, success)
	queue_free()

func _draw_pentagons():
	if not quest or not selected_variant:
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

func _update_success_rate():
	if not selected_variant:
		return
	var squad_stats = _calculate_squad_stats(agents)
	var rate = _get_success_rate(squad_stats, selected_variant)
	success_label.text = "Шанс успеха: %d%%" % int(rate * 100)

func _calculate_squad_stats(agents_array: Array) -> Dictionary:
	var stats = {"strenght": 0, "harisma": 0, "endurance": 0, "intellect": 0, "agility": 0}
	
	for agent in agents_array:
		stats.strenght += agent.strenght
		stats.harisma += agent.harisma
		stats.endurance += agent.endurance
		stats.intellect += agent.intellect
		stats.agility += agent.agility
		
	# Обрезаем каждый стат до максимума 10
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
	var y_3 = 0 + stats.agility * 10
	var x_3 = 0 + (64 * float(stats.agility * 10) / 100)
	var third_point = Vector2(x_3, y_3)
	
	var y_4 = 0 + stats.endurance * 10
	var x_4 = 0 - (64 * float(stats.endurance * 10) / 100)
	var four_point = Vector2(x_4, y_4)
	
	return PackedVector2Array([
		Vector2(0 - stats.strenght * 10, 0),
		Vector2(0, 0 - stats.intellect * 10),
		Vector2(0 + stats.harisma * 10, 0),
		third_point,
		four_point
	])
