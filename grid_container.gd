extends GridContainer

const ICON_HOURGLASS = preload("res://materials/hourglass.png")
const ICON_TIMER = preload("res://materials/timer.png")
const ICON_LEVEL_UP = preload("res://materials/levelup.png")

@onready var agent1 = $TextureRect
@onready var agent2 = $TextureRect2
@onready var agent3 = $TextureRect3
@onready var agent4 = $TextureRect4
@onready var agent5 = $TextureRect5
@onready var agent6 = $TextureRect6

func _ready() -> void:
	print("🟢 GridContainer загружен")
	PlayerStats.leveled_up.connect(refresh_all_slots)
	refresh_all_slots()

func refresh_slot(slot: TextureRect, agent: AgentStats) -> void:
	if not slot:
		return
		
	if not agent:
		slot.texture = preload("res://materials/zaglushka.jpeg")
		slot.agent = null
		var overlay = slot.get_node_or_null("StatusOverlay")
		if overlay:
			overlay.visible = false
		var level_up_overlay = slot.get_node_or_null("LevelUpOverlay")
		if level_up_overlay:
			level_up_overlay.visible = false
		return
		
	slot.agent = agent
	
	# 1. Основной спрайт
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = agent.sprite
	atlas_texture.region = Rect2(550, 20, 300, 250)
	slot.texture = atlas_texture
	
	# 2. Цвет для раненых
	if agent.is_wounded:
		slot.modulate = Color(1, 0.3, 0.3, 0.7)
	else:
		slot.modulate = Color(1, 1, 1, 1)
	
	# 3. Иконка статуса
	var overlay = slot.get_node_or_null("StatusOverlay")
	if not overlay:
		overlay = TextureRect.new()
		overlay.name = "StatusOverlay"
		overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
		overlay.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		overlay.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE  # ️ Клики проходят сквозь
		slot.add_child(overlay)
		
	match agent.current_status:
		AgentStats.Status.AVAILABLE:
			overlay.visible = false
		AgentStats.Status.ON_MISSION:
			overlay.visible = true
			overlay.texture = ICON_HOURGLASS
			overlay.modulate = Color(1, 1, 1, 0.7)
		AgentStats.Status.RESTING:
			overlay.visible = true
			overlay.texture = ICON_TIMER
			overlay.modulate = Color(1, 1, 1, 0.7)
	
	# 4. Иконка повышения уровня
	var level_up_overlay = slot.get_node_or_null("LevelUpOverlay")
	if not level_up_overlay:
		level_up_overlay = TextureRect.new()
		level_up_overlay.name = "LevelUpOverlay"
		level_up_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
		level_up_overlay.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		level_up_overlay.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		level_up_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE  # ⬅️ Клики проходят сквозь
		slot.add_child(level_up_overlay)
	
	if agent.skill_points > 0:
		level_up_overlay.visible = true
		level_up_overlay.texture = ICON_LEVEL_UP
		level_up_overlay.modulate = Color(1, 1, 1, 0.9)
	else:
		level_up_overlay.visible = false

func refresh_all_slots() -> void:
	print("🔄 Обновляем все слоты...")
	
	var slots = [agent1, agent2, agent3, agent4, agent5, agent6]
	var agents_count = PartyBox.get_agents_count()
	
	print("👥 Всего агентов в PartyBox: ", agents_count)
		# ⬇️ ОТЛАДКА: Показываем что реально в массиве
	for i in range(PartyBox.party.size()):
		var agent = PartyBox.party[i]
		if agent:
			print("  [", i, "] ", agent.agent_second_name, " (", agent.current_status, ")")
		else:
			print("  [", i, "] NULL")
	
	for i in range(slots.size()):
		var agent = PartyBox.get_agent(i)
		refresh_slot(slots[i], agent)
