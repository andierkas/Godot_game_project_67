extends Polygon2D

@onready var stren = $StrenghtStat
@onready var intel = $"IntellectStat"
@onready var agi = $"AgilityStat"
@onready var har = $"HarismaStat"
@onready var endur = $"EnduranceStat"

@export var agent: AgentStats
	
func update(_agent: AgentStats):
	set_agent_stats(_agent)
	stren.text = str(_agent.strenght)
	intel.text = str(_agent.intellect)
	agi.text = str(_agent.agility)
	har.text = str(_agent.harisma)
	endur.text = str(_agent.endurance)

func set_agent_stats(_agent: AgentStats):
	var y_3 = 0 + _agent.agility * 10
	var x_3 = 0 + (64 * float(_agent.agility * 10) / 100)
	var third_point = Vector2(x_3, y_3)
	var y_4 = 0 + _agent.endurance * 10
	var x_4 = 0 - (64 * float(_agent.endurance * 10) / 100)
	var four_point = Vector2(x_4, y_4)
	var vertices = PackedVector2Array([Vector2(0 - _agent.strenght*10, 0),Vector2(0, 0 - _agent.intellect * 10), Vector2(0 + _agent.harisma * 10, 0), third_point, four_point])
	self.polygon = vertices
