extends Control

func _ready():
	custom_minimum_size = Vector2(100, 100)
	# Добавляем цветной фон для видимости
	var bg = ColorRect.new()
	bg.color = Color.BLUE
	bg.size = Vector2(100, 100)
	add_child(bg)

func _get_drag_data(_at_position):
	print("✅ DRAG СРАБОТАЛ!")
	var preview = TextureRect.new()
	preview.color = Color.RED
	preview.size = Vector2(50, 50)
	set_drag_preview(preview)
	return {"test": true}

func _can_drop_data(_at_position, data):
	return true
