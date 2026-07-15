extends Node

var party: Array[AgentStats] = []

func add_agent(agent: AgentStats):
	party.append(agent)

func get_agent(index: int) -> AgentStats:
	if index >= 0 and index < party.size():
		return party[index]
	return null  # Возвращаем null если индекс вне границ
	
func remove_agent(index: int):
	if index >= 0 and index < party.size():
		party.remove_at(index)

func get_agents_count() -> int:
	return party.size()
