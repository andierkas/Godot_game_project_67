extends Control

@onready var agent_node = $fifth_agent


func _get_drag_data(at_position):
	var preview = _create_drag_preview()
	# Этот метод сработает автоматически для drag-and-drop
	if agent_node == null:
		return null
	set_drag_preview(preview)
	# Возвращаем САМ УЗЕЛ, который хотим перенести
	return {
		"dragged_control": self,
		"dragged_agent": agent_node,
		"original_parent": get_parent(),
		"original_index": get_index()
	}

func _can_drop_data(at_position, data):
	# Проверяем, что перетаскивают именно узел
	return typeof(data) == TYPE_DICTIONARY and data.has("dragged_control")

func _drop_data(at_position, data):
	var dragged_control = data["dragged_control"]
	var dragged_agent = data["dragged_agent"]
	
	if dragged_control == self:
		return  # На себя
	
	# Получаем родителя (контейнер с покемонами)
	var container = get_parent()
	var target_index = get_index()
	var dragged_index = dragged_control.get_index()
	container.move_child(dragged_control, target_index)
	container.move_child(self, dragged_index)


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
	
	# Делаем полупрозрачным
	container.modulate = Color(1, 1, 1, 0.7)
	
	return container
