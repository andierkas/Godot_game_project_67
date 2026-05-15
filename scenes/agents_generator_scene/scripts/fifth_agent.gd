extends Node2D


var agent: AgentStats

func update_agent():
	if agent:
		$SpriteAgent.texture = agent.sprite
		$NameAgent.text = agent.agent_second_name
