extends Panel

var current_tween: Tween = null
var showed: bool = true

func _on_button_pressed() -> void:
	print("Текущая позиция ДО анимации: ", self.position)
	
	# Отменяем текущий твин, если он есть
	if current_tween and current_tween.is_valid():
		current_tween.kill()
	
	if showed:
		# Создаём новый твин и сохраняем ссылку
		current_tween = create_tween()
		current_tween.tween_property(self, "position", Vector2(241, 1100), 1.0)
		showed = false
	else:
		current_tween = create_tween()
		current_tween.tween_property(self, "position", Vector2(241, 550), 0.3)
		showed = true
