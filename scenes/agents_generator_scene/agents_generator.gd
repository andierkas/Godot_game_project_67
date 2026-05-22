extends Control


@onready var agent_sprite = $Current_agent/SpriteAgent
@onready var agent_name = $Current_agent/NameAgent
@onready var pentastats = $Current_agent/FillPentagonStats
@onready var str_stat = $"Current_agent/Stats/Strenght Stat"
@onready var agi_stat = $"Current_agent/Stats/Agility Stat"
@onready var endur_stat = $"Current_agent/Stats/Endurance Stat"
@onready var int_stat = $"Current_agent/Stats/Intellect Stat"
@onready var har_stat = $"Current_agent/Stats/Harisma Stat"
@onready var aspect = $Current_agent/Background/Aspect
@onready var Gender_age = $Current_agent/Background/Gender_age

var agent_1 = AgentStats.new()
var agent_2 = AgentStats.new()
var agent_3 = AgentStats.new()
var agent_4 = AgentStats.new()
var agent_5 = AgentStats.new()

#func _ready():
	#show_current_sprite(agent_1)
	#var first_agent = $Agentparty/dragbox/Panel/Agent
	#first_agent.agent = agent_1
	#first_agent.update_agent()
	#var second_agent = $Agentparty/dragbox/Panel2/Agent
	#second_agent.agent = agent_2
	#second_agent.update_agent()
	#var third_agent = $Agentparty/ForDrag3/Third_agent
	#third_agent.agent = agent_3
	#third_agent.update_agent()
	#var four_agent = $Agentparty/ForDrag4/four_agent
	#four_agent.agent = agent_4
	#four_agent.update_agent()
	#var fifth_agent = $Agentparty/ForDrag5/fifth_agent
	#fifth_agent.agent = agent_5
	#fifth_agent.update_agent()

func show_current_sprite(agent: AgentStats):
	agent_sprite.texture = agent.sprite
	agent_name.text = agent.agent_second_name + " " + agent.agent_first_name + " " + agent.agent_last_name
	if agent.gender == true:
		Gender_age.text = "Male," + " " + str(agent.age)
	else:
		Gender_age.text = "Female," + " " + str(agent.age)
	set_agent_stats(agent)


func set_agent_stats(agent: AgentStats):
	var y_3 = 0 + agent.agility * 10
	var x_3 = 0 + (64 * float(agent.agility * 10) / 100)
	var third_point = Vector2(x_3, y_3)
	var y_4 = 0 + agent.endurance * 10
	var x_4 = 0 - (64 * float(agent.endurance * 10) / 100)
	var four_point = Vector2(x_4, y_4)
	var vertices = PackedVector2Array([Vector2(0 - agent.strenght*10, 0),Vector2(0, 0 - agent.intellect * 10), Vector2(0 + agent.harisma * 10, 0), third_point, four_point])
	pentastats.polygon = vertices
	print(pentastats.polygon)
	str_stat.text = str(agent.strenght)
	int_stat.text = str(agent.intellect)
	endur_stat.text = str(agent.endurance)
	agi_stat.text = str(agent.agility)
	har_stat.text = str(agent.harisma)
	
	
