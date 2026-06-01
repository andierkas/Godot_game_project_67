extends Panel

var showed = true


func _on_button_pressed() -> void:
	print("Текущая позиция ДО анимации: ", self.position)
	if showed:
		create_tween().tween_property(self, "position", Vector2(90, 900), 1.0)
		showed = false
	else:
		create_tween().tween_property(self, "position", Vector2(90, 477), 0.3)
		showed = true
