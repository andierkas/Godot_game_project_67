extends TextureRect

@export var agent: AgentStats
@export var container_type: String

func _get_drag_data(at_position: Vector2) -> Variant:
		# Если агент занят, запрещаем перетаскивание
	if agent.current_status == AgentStats.Status.ON_MISSION:
		return null 
	if container_type == "target":
		print("target")
		return null
	if not agent:
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

func _drop_data(at_position: Vector2, data: Variant) -> void:
	agent = data.agent
	update_texture()


func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		if not is_drag_successful():
			self.show()

func update_texture() -> void:
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
