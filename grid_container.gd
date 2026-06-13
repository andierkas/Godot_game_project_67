extends GridContainer

const ICON_HOURGLASS = preload("res://materials/hourglass.png")
const ICON_TIMER = preload("res://materials/timer.png")

@onready var agent1 = $TextureRect
@onready var agent2 = $TextureRect2
@onready var agent3 = $TextureRect3
@onready var agent4 = $TextureRect4
@onready var agent5 = $TextureRect5
@onready var agent6 = $TextureRect6

func _ready() -> void:
	print("🟢 GridContainer загружен")
	refresh_all_slots()

func refresh_slot(slot: TextureRect, agent: AgentStats) -> void:
	if not slot:
		return
		
	if not agent:
		slot.texture = null
		slot.agent = null
		var overlay = slot.get_node_or_null("StatusOverlay")
		if overlay:
			overlay.visible = false
		return
		
	slot.agent = agent
	
	# 1. Настраиваем основной спрайт агента
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = agent.sprite
	atlas_texture.region = Rect2(550, 20, 300, 250)
	slot.texture = atlas_texture
	
	# 2. Настраиваем иконку статуса (overlay)
	var overlay = slot.get_node_or_null("StatusOverlay")
	if not overlay:
		overlay = TextureRect.new()
		overlay.name = "StatusOverlay"
		overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
		overlay.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		overlay.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		slot.add_child(overlay)
		
	# 3. Меняем иконку в зависимости от статуса
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

func refresh_all_slots() -> void:
	print("🔄 Обновляем все слоты...")
	
	
	var slots = [agent1, agent2, agent3, agent4, agent5, agent6]
	var agents_count = PartyBox.get_agents_count()
	
	print(" Всего агентов в PartyBox: ", agents_count)
	
	for i in range(slots.size()):
		
		var agent = PartyBox.get_agent(i)
		refresh_slot(slots[i], agent)
