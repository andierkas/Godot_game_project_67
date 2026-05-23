extends Control

@onready var agent_1 = $Agentparty/dragbox/Panel/Agent
@onready var agent_2 = $Agentparty/dragbox/Panel2/Agent
@onready var agent_3 = $Agentparty/dragbox/Panel3/Agent
@onready var agent_4 = $Agentparty/dragbox/Panel4/Agent
@onready var agent_5 = $Agentparty/dragbox/Panel5/Agent

@export var current_agent: AgentStats

func _ready():
	current_agent = agent_1.agent

func _on_button_2_pressed() -> void:
	get_tree().reload_current_scene()

func _on_button_pressed() -> void:
	SceneLoader.load_scene("res://scenes/loadgame_scene/loadgame_scene.tscn")


func _on_next_pressed() -> void:
	PartyBox.add_agent(agent_1.agent)
	PartyBox.add_agent(agent_2.agent)
	PartyBox.add_agent(agent_3.agent)
	SceneLoader.load_scene("res://scenes/Gameplay_scene/day.tscn")
