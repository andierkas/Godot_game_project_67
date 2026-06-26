extends TextureRect

@onready var sprite = $spritequest
@onready var namequest = $NameQuest
@onready var quest_desc = $descript
@onready var target_grid = $GridContainer
@onready var animScreen = $AnimScreen

signal quest_accepted(agents: Array, target_pos: Vector2)

@export var quest: Quest
var quest_target_position: Vector2

func _ready() -> void:
	print("🟢 Панель квеста загружена")
	animScreen.play("screen_animation")

func show_quest(quest_data: Quest, target_pos: Vector2):
	quest = quest_data
	quest_target_position = target_pos
	namequest.text = quest.name
	quest_desc.text = quest.description
	sprite.texture = quest.slide
	show()

func _on_button_pressed() -> void:
	print("❌ Кнопка Close нажата")
	queue_free()

func _on_next_pressed() -> void:
	print("🟡 Кнопка Next нажата!")
	
	var selected_agents = []
	
	for slot in target_grid.get_children():
		if slot.agent != null and not slot.agent.is_dummy:
			selected_agents.append(slot.agent)
	
	print("📦 Выбрано агентов: ", selected_agents.size())
	
	if selected_agents.size() == 0:
		print("⚠️ Нужно выбрать хотя бы одного агента!")
		return
	
	quest_accepted.emit(selected_agents, quest_target_position)
	queue_free()
