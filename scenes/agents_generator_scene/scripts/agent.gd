extends Node2D

@export var agent = AgentStats.new()

func _ready() -> void:
	update_agent()


func update_agent():
	if agent:
		$SpriteAgent.texture = agent.sprite
		$NameAgent.text = agent.agent_second_name
		## тут генерация пятиугольника
		var y_3 = 0 + agent.agility * 10
		var x_3 = 0 + (64 * float(agent.agility * 10) / 100)
		var third_point = Vector2(x_3, y_3)
		var y_4 = 0 + agent.endurance * 10
		var x_4 = 0 - (64 * float(agent.endurance * 10) / 100)
		var four_point = Vector2(x_4, y_4)
		var vertices = PackedVector2Array([Vector2(0 - agent.strenght*10, 0),Vector2(0, 0 - agent.intellect * 10), Vector2(0 + agent.harisma * 10, 0), third_point, four_point])
		$FillPentagonStats.polygon = vertices

func hideagent():
	$ColorRect.hide()
	$FillPentagonStats.hide()
	$NameAgent.hide()
	$SpriteAgent.hide()
	
func showagent():
	$ColorRect.show()
	$FillPentagonStats.show()
	$NameAgent.show()
	$SpriteAgent.show()
