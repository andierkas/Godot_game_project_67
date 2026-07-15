extends Node

# Множитель XP для агентов в зависимости от размера отряда
func get_squad_multiplier(squad_size: int) -> float:
	match squad_size:
		1: return 1.5
		2: return 1.25
		3, 4: return 1.0
		5, 6: return 0.75
		_: return 1.0

# Рассчитать вариативный XP (75-150% от базы)
func calculate_variable_xp(base_xp: int) -> int:
	var multiplier = randf_range(0.75, 1.5)
	var result = int(base_xp * multiplier)
	print("🎲 Вариация XP: база=", base_xp, " множитель=", multiplier, " результат=", result)
	return result

# Рассчитать награду для отряда
# Возвращает словарь: { "player_xp": int, "agent_xp_per_person": int }
func calculate_rewards(base_xp: int, squad_size: int) -> Dictionary:
	if squad_size <= 0:
		print("⚠️ Размер отряда = 0, награда не начисляется")
		return {"player_xp": 0, "agent_xp_per_person": 0}
	
	# PlayerStats (диспетчер) получает полный базовый XP с вариацией
	var player_xp = calculate_variable_xp(base_xp)
	
	# Агенты получают XP с множителем за размер отряда
	var agent_multiplier = get_squad_multiplier(squad_size)
	var total_agent_xp = int(base_xp * agent_multiplier)
	var xp_per_agent = int(total_agent_xp / float(squad_size))
	
	print("💰 Награда: диспетчер=", player_xp, " XP, каждый агент=", xp_per_agent, " XP (множитель отряда=", agent_multiplier, ")")
	
	return {
		"player_xp": player_xp,
		"agent_xp_per_person": xp_per_agent
	}
