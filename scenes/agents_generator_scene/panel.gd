extends Panel

@onready var agent1 = $Agent
@export var agent_data: AgentStats

func _ready() -> void:
	update_ui()
	
func update_ui() -> void:
	agent_data = agent1.agent
	
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
	var tmp = agent_data
	agent_data = data.agent1.agent
	data.agent1.agent = tmp
	agent1.showagent()
	data.agent1.show()
	update_ui()
	data.update_ui()
	data.agent1.update_agent()
