extends Node

# Здоровье игрока (города/диспетчера)
@export var health: int = 100
@export var max_health: int = 100

# Общий опыт и уровень игрока
@export var xp: int = 0
@export var level: int = 1

# Сигналы для UI
signal health_changed
signal leveled_up

func _ready() -> void:
	print("🏙️ PlayerStats загружен. Здоровье: ", health, "/", max_health)

# Добавить XP игроку
func add_xp(amount: int) -> void:
	if amount <= 0:
		return
	
	xp += amount
	print("📈 Игрок получил ", amount, " XP (всего: ", xp, ")")
	
	# Проверяем повышение уровня
	var xp_to_next = get_xp_to_next_level()
	while xp >= xp_to_next:
		xp -= xp_to_next
		level += 1
		xp_to_next = get_xp_to_next_level()
		_on_level_up()

# Сколько XP нужно для следующего уровня (та же формула что у агентов)
func get_xp_to_next_level() -> int:
	return int(200 * pow(1.25, level - 1))

# Что происходит при повышении уровня игрока
func _on_level_up() -> void:
	if PartyBox.get_agents_count() < 6:
		var new_agent = AgentStats.new()
		PartyBox.add_agent(new_agent)
	print(" Игрок повысил уровень до ", level, "!")
	leveled_up.emit()

# Получить урон (при провале квеста)
func take_damage(amount: int) -> void:
	if amount <= 0:
		return
	
	health -= amount
	if health < 0:
		health = 0
	
	print("💔 Игрок получил ", amount, " урона! Здоровье: ", health, "/", max_health)
	health_changed.emit()
	
	if health <= 0:
		_on_game_over()

# Конец игры (если нужно)
func _on_game_over() -> void:
	print("☠️ GAME OVER! Город пал...")
	# Тут можно вызвать сцену проигрыша
	# get_tree().change_scene_to_file("res://scenes/game_over.tscn")

# Лечение (можно использовать позже)
func heal(amount: int) -> void:
	health += amount
	if health > max_health:
		health = max_health
	print(" Игрок восстановил ", amount, " HP. Здоровье: ", health, "/", max_health)
	health_changed.emit()
