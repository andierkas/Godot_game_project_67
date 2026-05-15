extends Resource
class_name AgentStats
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

#Спрайты
@export var sprite: Texture2D

func _init():
	var rand_gender = randi_range(0,1)
	if rand_gender == 1:
		gender = true
		var available_sprites : Array[Texture2D] = []
		var dir = DirAccess.open("res://materials/Sprite_agent/male/")
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "" and file_name != null:
				if file_name.ends_with(".png"):
					var texture = load("res://materials/Sprite_agent/male/" + file_name)
					if texture:
						available_sprites.append(texture)
				file_name = dir.get_next()
			dir.list_dir_end()
		var random_index = randi() % available_sprites.size()
		sprite = available_sprites[random_index]
	else:
		var available_sprites : Array[Texture2D] = []
		var dir = DirAccess.open("res://materials/Sprite_agent/female/")
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "" and file_name != null:
				if file_name.ends_with(".png"):
					var texture = load("res://materials/Sprite_agent/female/" + file_name)
					if texture:
						available_sprites.append(texture)
				file_name = dir.get_next()
			dir.list_dir_end()
		var random_index = randi() % available_sprites.size()
		sprite = available_sprites[random_index]
	pick_random_name()
	var _max_stats = 0
	var array_stats = [1,1,1,1,1]
	while _max_stats < 10:
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
		var file_names = FileAccess.open("res://materials/names_agent/male_first_names.txt", FileAccess.READ)
		var file_second = FileAccess.open("res://materials/names_agent/male_last_name.txt", FileAccess.READ)
		var file_patronymics = FileAccess.open("res://materials/names_agent/male_patronymics.txt", FileAccess.READ)
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
		var file_names = FileAccess.open("res://materials/names_agent/female_first_names.txt", FileAccess.READ)
		var file_second = FileAccess.open("res://materials/names_agent/female_last_name.txt", FileAccess.READ)
		var file_patronymics = FileAccess.open("res://materials/names_agent/female_patronymics.txt", FileAccess.READ)
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
