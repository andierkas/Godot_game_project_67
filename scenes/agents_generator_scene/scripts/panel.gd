extends Panel

@onready var agent1 = $Agent
	
func _get_drag_data(_at_position: Vector2) -> Variant:
	if not agent1:
		return
	var preview = duplicate()
	var c = Control.new()
	c.add_child(preview)
	preview.position -= Vector2(25,25)
	
	set_drag_preview(c)
	agent1.hideagent()
	return self

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var tmp = agent1.agent
	agent1.agent = data.agent1.agent
	data.agent1.agent = tmp
	agent1.update_agent()
	data.agent1.update_agent()
	agent1.showagent()
	data.agent1.showagent()

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		if not is_drag_successful():
			agent1.showagent()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var info_agent = get_node("../../../Current_agent")
			if info_agent and agent1:
				info_agent.updateagent(agent1.agent)
