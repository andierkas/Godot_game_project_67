extends Control

@onready var agent_sprite = $TextureRect/SpriteAgent
@onready var agent_name = $TextureRect/NameAgent
var current_agent: AgentStats

func _ready():
	create_agent()
	
	
func create_agent():
	var new_agent = AgentStats.new()
	new_agent.agent_first_name = "Anton"
	new_agent.sprite = load("res://materials/Sprite_agent/1.jpg")
	new_agent.agent_second_name = "Klichko"
	new_agent.agent_last_name = "Ivanovich"
	var _max_stats = 0
	#var _strenght = 1 
	#var _harisma = 1
	#var _endurance = 1 
	#var _intellect = 1
	#var _agility = 1
	
	var array_stats = [1,1,1,1,1]
	while _max_stats < 9:
		var index = randi_range(0,4)
		array_stats[index] += randi_range(0,1)
		_max_stats += 1
	new_agent.strenght = array_stats[0]
	new_agent.harisma = array_stats[1]
	new_agent.agility = array_stats[2]
	new_agent.endurance = array_stats[3]
	new_agent.intellect = array_stats[4]
	new_agent.generate_portrait()
	
	current_agent = new_agent
	show_sprite(current_agent)
	print("Агент создан")
	print(agent_sprite.texture)
	
	
func show_sprite(agent: AgentStats):
	agent_sprite.texture = agent.portrait
	agent_name.text = agent.agent_first_name + " " + agent.agent_second_name + " " + agent.agent_last_name
	
	
