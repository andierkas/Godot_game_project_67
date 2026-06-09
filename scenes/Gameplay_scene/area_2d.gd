extends Area2D

@export var quest_data: Quest 

signal open_window_quest (quest: Quest)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Клик по маркеру!")
		open_window_quest.emit(quest_data)
