extends CanvasLayer

func _ready() -> void:
	pass
	
func _on_close_button_pressed() -> void:
	queue_free()
