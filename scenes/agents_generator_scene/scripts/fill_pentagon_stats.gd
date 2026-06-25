extends Polygon2D

@onready var str = $StrenghtStat
@onready var intel = $"IntellectStat"
@onready var agi = $"AgilityStat"
@onready var har = $"HarismaStat"
@onready var endur = $"EnduranceStat"

@export var agent: AgentStats
	
func update(agent: AgentStats):
	set_agent_stats(agent)
	str.text = str(agent.strenght)
	intel.text = str(agent.intellect)
	agi.text = str(agent.agility)
	har.text = str(agent.harisma)
	endur.text = str(agent.endurance)

func set_agent_stats(agent: AgentStats):
	var y_3 = 0 + agent.agility * 10
	var x_3 = 0 + (64 * float(agent.agility * 10) / 100)
	var third_point = Vector2(x_3, y_3)
	var y_4 = 0 + agent.endurance * 10
	var x_4 = 0 - (64 * float(agent.endurance * 10) / 100)
	var four_point = Vector2(x_4, y_4)
	var vertices = PackedVector2Array([Vector2(0 - agent.strenght*10, 0),Vector2(0, 0 - agent.intellect * 10), Vector2(0 + agent.harisma * 10, 0), third_point, four_point])
	self.polygon = vertices
