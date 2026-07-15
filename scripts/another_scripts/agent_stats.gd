extends Resource
class_name AgentStats

# Создаем перечисление
enum Status {
	AVAILABLE, # Свободен
	ON_MISSION, # В пути
	RESTING # Отдыхает
}

# Создаем переменную этого типа и задаем значение по умолчанию
@export var current_status: Status = Status.AVAILABLE
@export var is_dummy: bool = false #статус для заглушки
@export var is_wounded: bool = false # false = здоров, true = ранен

# Статы
@export var strenght: int 
@export var harisma: int 
@export var endurance: int 
@export var intellect: int
@export var agility: int 

# ФИО
@export var agent_first_name: String
@export var agent_second_name: String
@export var agent_last_name: String
@export var gender: bool #1 - мужчина, 0 - женщина
@export var age: int

#Спрайты
@export var sprite: Texture2D

# ⬇️ НОВЫЕ ПОЛЯ: прогрессия и прокачка
@export var xp: int = 0
@export var level: int = 1
@export var skill_points: int = 0

# Сигнал для UI (чтобы показать иконку ⬆️)
signal leveled_up
signal skill_points_changed

func _init():
	var rand_gender = randi_range(0,1)
	age = randi_range(18,35)
	if rand_gender == 1:
		gender = true
		var available_sprites : Array[Texture2D] = []
		var dir = DirAccess.open("res://materials/base_scenes/agents_generator/sprite_agent/male/")
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "" and file_name != null:
				if file_name.ends_with(".png"):
					var texture = load("res://materials/base_scenes/agents_generator/sprite_agent/male/" + file_name)
					if texture:
						available_sprites.append(texture)
				file_name = dir.get_next()
			dir.list_dir_end()
		var random_index = randi() % available_sprites.size()
		sprite = available_sprites[random_index]
	else:
		var available_sprites : Array[Texture2D] = []
		var dir = DirAccess.open("res://materials/base_scenes/agents_generator/sprite_agent/female/")
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "" and file_name != null:
				if file_name.ends_with(".png"):
					var texture = load("res://materials/base_scenes/agents_generator/sprite_agent/female/" + file_name)
					if texture:
						available_sprites.append(texture)
				file_name = dir.get_next()
			dir.list_dir_end()
		var random_index = randi() % available_sprites.size()
		sprite = available_sprites[random_index]
	pick_random_name()
	var _max_stats = 0
	var array_stats = [1,1,1,1,1]
	while _max_stats < 8:
		var index = randi_range(0,4)
		array_stats[index] += randi_range(0,2)
		_max_stats += 1
	strenght = array_stats[0]
	harisma = array_stats[1]
	agility = array_stats[2]
	endurance = array_stats[3]
	intellect = array_stats[4]

func pick_random_name():
	var _array_names: Array[String]
	var _array_second_names: Array[String]
	var _array_patronymics_names: Array[String]
	if gender:
		var file_names = FileAccess.open("res://something/names_agent/male_first_names.txt", FileAccess.READ)
		var file_second = FileAccess.open("res://something/names_agent/male_last_name.txt", FileAccess.READ)
		var file_patronymics = FileAccess.open("res://something/names_agent/male_patronymics.txt", FileAccess.READ)
		while file_names.get_position() < file_names.get_length():
			var line = file_names.get_line()
			line = line.strip_edges()
			if line != "":
				_array_names.append(line)
		while file_second.get_position() < file_second.get_length():
			var line = file_second.get_line()
			line = line.strip_edges()
			if line != "":
				_array_second_names.append(line)
		while file_patronymics.get_position() < file_patronymics.get_length():
			var line = file_patronymics.get_line()
			line = line.strip_edges()
			if line != "":
				_array_patronymics_names.append(line)
		agent_first_name = _array_names.pick_random()
		agent_second_name = _array_second_names.pick_random()
		agent_last_name = _array_patronymics_names.pick_random()
	else:
		var file_names = FileAccess.open("res://something/names_agent/female_first_names.txt", FileAccess.READ)
		var file_second = FileAccess.open("res://something/names_agent/female_last_name.txt", FileAccess.READ)
		var file_patronymics = FileAccess.open("res://something/names_agent/female_patronymics.txt", FileAccess.READ)
		while file_names.get_position() < file_names.get_length():
			var line = file_names.get_line()
			line = line.strip_edges()
			if line != "":
				_array_names.append(line)
		while file_second.get_position() < file_second.get_length():
			var line = file_second.get_line()
			line = line.strip_edges()
			if line != "":
				_array_second_names.append(line)
		while file_patronymics.get_position() < file_patronymics.get_length():
			var line = file_patronymics.get_line()
			line = line.strip_edges()
			if line != "":
				_array_patronymics_names.append(line)
		agent_first_name = _array_names.pick_random()
		agent_second_name = _array_second_names.pick_random()
		agent_last_name = _array_patronymics_names.pick_random()

# ⬇️ НОВЫЕ МЕТОДЫ: XP и прокачка

# Получить сколько XP нужно для следующего уровня
func get_xp_to_next_level() -> int:
	return int(200 * pow(1.25, level - 1))

# Добавить XP агенту
func add_xp(amount: int) -> void:
	if amount <= 0:
		return
	
	xp += amount
	print("📈 Агент ", agent_second_name, " получил ", amount, " XP (всего: ", xp, "/", get_xp_to_next_level(), ")")
	
	# Проверяем повышение уровня (может быть несколько уровней сразу)
	while xp >= get_xp_to_next_level():
		xp -= get_xp_to_next_level()
		level += 1
		_on_level_up()
	
	skill_points_changed.emit()

# Что происходит при повышении уровня
func _on_level_up() -> void:
	print("️ Агент ", agent_second_name, " повысил уровень до ", level, "!")
	
	if level % 2 == 0:
		# ЧЁТНЫЙ уровень (2, 4, 6...) — игрок сам выбирает
		skill_points += 1
		print(" Выдан 1 skillpoint для ручного распределения")
	else:
		# НЕЧЁТНЫЙ уровень (3, 5, 7...) — случайное распределение
		_auto_distribute_skill_point()
		print("🎲 Skillpoint распределён случайно")
	
	leveled_up.emit()
	skill_points_changed.emit()

# Случайное распределение skillpoint (нечётные уровни)
func _auto_distribute_skill_point() -> void:
	var stats_names = ["strenght", "harisma", "agility", "endurance", "intellect"]
	var random_stat = stats_names[randi() % stats_names.size()]
	
	# Увеличиваем случайный стат на 1
	match random_stat:
		"strenght": strenght += 1
		"harisma": harisma += 1
		"agility": agility += 1
		"endurance": endurance += 1
		"intellect": intellect += 1
	
	print("🎲 Случайно повышен стат: ", random_stat, " (теперь: ", get(random_stat), ")")

# Ручное распределение skillpoint (вызывается из UI профиля агента)
func spend_skill_point(stat_name: String) -> bool:
	if skill_points <= 0:
		print("⚠️ Нет доступных skillpoints!")
		return false
	
	# Проверяем что такой стат существует
	if not ["strenght", "harisma", "agility", "endurance", "intellect"].has(stat_name):
		print("⚠️ Неизвестный стат: ", stat_name)
		return false
	
	# Тратим skillpoint и повышаем стат
	skill_points -= 1
	set(stat_name, get(stat_name) + 1)
	
	print("✅ Повышен стат ", stat_name, " до ", get(stat_name), ". Осталось skillpoints: ", skill_points)
	skill_points_changed.emit()
	return true

# Получить полное имя агента
func get_full_name() -> String:
	return agent_first_name + " " + agent_last_name + " " + agent_second_name
