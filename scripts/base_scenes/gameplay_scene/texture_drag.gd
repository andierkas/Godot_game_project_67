extends TextureRect

@export var agent: AgentStats
@export var container_type: String

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not agent:
		return null
	
	if not _is_quest_panel_open():
		return null
	
	if agent.current_status == AgentStats.Status.ON_MISSION:
		return null
	if agent.current_status == AgentStats.Status.RESTING:
		return null
	
	if container_type == "target":
		return null
	
	var preview = duplicate()
	var c = Control.new()
	c.add_child(preview)
	preview.position -= Vector2(25,25)
	preview.modulate = Color(1,1,1,0.8)
	set_drag_preview(c)
	return self

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	if not _data.agent:
		return false
	if if_agent_already(_data.agent):
		return false
	if _data.container_type == "source" and container_type == "target": 
		return true
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	agent = data.agent
	update_texture()

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		if not is_drag_successful():
			self.show()

func update_texture() -> void:
	if not agent:
		texture = null
		return
	
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = agent.sprite
	atlas_texture.region = Rect2(550,20,300,250)
	texture = atlas_texture

func if_agent_already(agent_to_check) -> bool:
	var parent = get_parent()
	for slot in parent.get_children():
		if slot != self and slot.agent == agent_to_check:
			return true
	return false

func _is_quest_panel_open() -> bool:
	var quest_panel = get_node_or_null("/root/Main/QuestPanel")
	if quest_panel:
		return quest_panel.visible
	return false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Если панель квеста открыта — не открываем профиль (там работает drag)
		if _is_quest_panel_open():
			return
		
		# Если агента нет — ничего не делаем
		if not agent:
			return
		
		# Открываем профиль агента (ВСЕГДА, не только при skillpoints > 0)
		print("🖱️ Клик по агенту: ", agent.agent_second_name)
		
		var agent_profile = get_node_or_null("/root/Main/AgentProfile")
		if agent_profile and agent_profile.has_method("open_profile"):
			agent_profile.open_profile(agent)
		else:
			print("⚠️ AgentProfile не найден!")
