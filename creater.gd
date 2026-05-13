extends Control

@onready var agent_sprite = $TextureRect/SpriteAgent
var current_agent: AgentStats

func _ready():
	create_agent()
	
	
func create_agent():
	var new_agent = AgentStats.new()
	new_agent.agent_first_name = "Антон"
	new_agent.sprite = load("res://materials/Sprite_agent/1.jpg")
	
	new_agent.generate_portrait()
	
	current_agent = new_agent
	show_sprite(current_agent)
	print("Агент создан")
	print(agent_sprite.texture)
	
	
func show_sprite(agent: AgentStats):
	agent_sprite.texture = agent.portrait
