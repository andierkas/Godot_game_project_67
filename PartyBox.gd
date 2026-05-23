extends Node

var party: Array[AgentStats] = []

func add_agent(agent: AgentStats):
	party.append(agent)

func get_agent(index: int) -> AgentStats:
	return party[index]
	
func remove_agent(index: int):
	party.remove_at(index)
