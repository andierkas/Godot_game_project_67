extends Control

func _ready():
	# Делаем узел видимым и кликабельным
	custom_minimum_size = Vector2(200, 200)
	
	# Добавляем фон для наглядности
	var bg = ColorRect.new()
	bg.color = Color.BLUE
	bg.size = Vector2(200, 200)
	add_child(bg)

func _get_drag_data(at_position):
	print("DRAG STARTED!")  # Ключевое сообщение
	var preview = ColorRect.new()
	preview.color = Color.RED
	preview.size = Vector2(50, 50)
	set_drag_preview(preview)
	return {"data": "test"}

func _can_drop_data(at_position, data):
	return true

func _drop_data(at_position, data):
	print("DROP!")
