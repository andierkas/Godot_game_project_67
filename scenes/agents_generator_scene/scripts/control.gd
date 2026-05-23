extends Control

@onready var agent_node = $First_agent
@onready var colorsheet = $First_agent/ColorRect
@onready var icon = $First_agent/SpriteAgent
@onready var text_name = $First_agent/NameAgent
@onready var penta = $First_agent/FillPentagonStats

func _get_drag_data(at_position):
	var preview = _create_drag_preview()
	# Этот метод сработает автоматически для drag-and-drop
	if agent_node == null:
		return null
	set_drag_preview(preview)
	colorsheet.color = Color(0,0,0,0)
	icon.texture = null
	text_name.text = ""
	penta.polygon = PackedVector2Array([Vector2(0,0)])
	# Возвращаем САМ УЗЕЛ, который хотим перенести
	return {
		"dragged_control": self,
		"dragged_agent": agent_node,
		"original_parent": get_parent(),
		"original_index": get_index()
	}

func _can_drop_data(_pos, data):
	# Проверяем, что перетаскивают именно узел
	return data is Control

func _drop_data(_pos, data):
	var dragged_control = data["dragged_control"]
	var dragged_agent = data["dragged_agent"]
	var dragged_z_index = data.get("original_z_index", 0)
	
	if dragged_control == self:
		return 
	
	var my_z = self.z_index
	self.z_index = dragged_z_index
	dragged_control.z_index = my_z
	
	# Получаем родителя (контейнер с покемонами)
	var container = get_parent()
	var target_index = get_index()
	var dragged_index = dragged_control.get_index()
	container.move_child(dragged_agent, target_index)
	container.move_child(self, dragged_index)
	
	var temp_position = self.position
	self.position = dragged_control.position
	dragged_control.position = temp_position

func _create_drag_preview() -> Control:
	# Создаём контейнер
	var container = Control.new()
	container.size = Vector2(0, 0)
	
	# Клонируем ВЕСЬ First_agent (копия для превью)
	var clone_agent = agent_node.duplicate()
	
	# Переносим clone_agent в контейнер
	container.add_child(clone_agent)
	
	# Настраиваем позицию клона
	clone_agent.position = Vector2(-180, -100)
	
	
	return container
