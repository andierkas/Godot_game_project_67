extends Node

const SquadScene = preload("res://scenes/Squad.tscn")
const QuestPanelScene = preload("res://scenes/Gameplay_scene/questdescript.tscn")

@onready var base_spawn = $Base

func _ready() -> void:
	print(" Главная сцена загружена")
	# Подключаем сигнал от маркера квеста
	if $questmark/Mark:
		$questmark/Mark.quest_clicked.connect(_on_quest_clicked)

func _on_quest_clicked(quest_data: Quest, target_pos: Vector2) -> void:
	print("🎯 Получен запрос на открытие квеста!")
	
	var panel = QuestPanelScene.instantiate()
	add_child(panel)
	#panel.position = get_viewport().size / 2
	
	panel.show_quest(quest_data, target_pos)
	
	# ВАЖНО: Подключаем сигнал принятия квеста
	panel.quest_accepted.connect(_on_quest_accepted)

func _on_quest_accepted(agents: Array, target_pos: Vector2) -> void:
	print(" КВЕСТ ПРИНЯТ! Создаем отряд...")
	
	var squad = SquadScene.instantiate()
	
	if base_spawn:
		squad.position = base_spawn.global_position
	else:
		squad.position = Vector2(400, 300)
	
	add_child(squad)
	squad.setup(agents, target_pos)
	
	for agent in agents:
		agent.current_status = AgentStats.Status.ON_MISSION
	
	print("✨ Отряд создан и отправлен!")
