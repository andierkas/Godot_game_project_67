extends Panel

signal solution_chosen(solution_id: int)

@onready var namequest = $NameQuest
@onready var quest_desc = $descript
@onready var sprite = $spritequest

@export var quest: Quest

func _ready() -> void:
	print("🟢 Панель решения загружена")

func show_quest(quest_data: Quest):
	quest = quest_data
	if quest:
		namequest.text = quest.name
		quest_desc.text = quest.description
		sprite.texture = quest.slide
	show()

func _on_solution_1_pressed() -> void:
	print("Выбрано решение 1")
	solution_chosen.emit(1)
	queue_free()

func _on_solution_2_pressed() -> void:
	print("Выбрано решение 2")
	solution_chosen.emit(2)
	queue_free()

func _on_close_pressed() -> void:
	queue_free()
