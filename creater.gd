extends Control


@onready var agent_sprite = $Current_agent/SpriteAgent
@onready var agent_name = $Current_agent/NameAgent
@onready var pentastats = $Current_agent/FillPentagonStats
@onready var str_stat = $"Current_agent/Stats/Strenght Stat"
@onready var agi_stat = $"Current_agent/Stats/Agility Stat"
@onready var endur_stat = $"Current_agent/Stats/Endurance Stat"
@onready var int_stat = $"Current_agent/Stats/Intellect Stat"
@onready var har_stat = $"Current_agent/Stats/Harisma Stat"

var agent_1 = AgentStats.new()
var agent_2 = AgentStats.new()
var agent_3 = AgentStats.new()
var agent_4 = AgentStats.new()
var agent_5 = AgentStats.new()

func _ready():
	show_current_sprite(agent_1)

func show_current_sprite(agent: AgentStats):
	agent_sprite.texture = agent.sprite
	agent_name.text = agent.agent_second_name + " " + agent.agent_first_name + " " + agent.agent_last_name
	set_agent_stats(agent)


func set_agent_stats(agent: AgentStats):
	var y_3 = 420 + agent.agility * 10
	var x_3 = 724 + (64 * float(agent.agility * 10) / 100)
	var third_point = Vector2(x_3, y_3)
	var y_4 = 420 + agent.endurance * 10
	var x_4 = 724 - (64 * float(agent.endurance * 10) / 100)
	var four_point = Vector2(x_4, y_4)
	var vertices = PackedVector2Array([Vector2(724 - agent.strenght*10, 420),Vector2(724, 420 - agent.intellect * 10), Vector2(724 + agent.harisma * 10, 420), third_point, four_point])
	pentastats.polygon = vertices
	print(pentastats.polygon)
	str_stat.text = str(agent.strenght)
	int_stat.text = str(agent.intellect)
	endur_stat.text = str(agent.endurance)
	agi_stat.text = str(agent.agility)
	har_stat.text = str(agent.harisma)
	
