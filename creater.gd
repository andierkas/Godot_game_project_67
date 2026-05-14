extends Control

@onready var agent_sprite = $TextureRect/SpriteAgent
@onready var agent_name = $TextureRect/NameAgent

@onready var pentastats = $TextureRect/FillPentagonStats
@onready var str_stat = $"TextureRect/Strenght Stat"
@onready var agi_stat = $"TextureRect/Agility Stat"
@onready var endur_stat = $"TextureRect/Endurance Stat"
@onready var int_stat = $"TextureRect/Intellect Stat"
@onready var har_stat = $"TextureRect/Harisma Stat"

var sprites_folder = "res://materials/Sprite_agent/"
var available_sprites: Array[Texture2D] = []
var current_agent: AgentStats
var name_folder: String

func _ready():
	load_sprites()
	create_agent()
	show_sprite(current_agent)	
	
func create_agent():
	var new_agent = AgentStats.new()
	var rand_gender = randi_range(0,1)
	if rand_gender == 1:
		new_agent.gender = true
	else:
		new_agent.gender = false
	pick_random_sprite(new_agent)
	pick_random_name(new_agent)
	var _max_stats = 0

	var array_stats = [1,1,1,1,1]
	while _max_stats < 10:
		var index = randi_range(0,4)
		array_stats[index] += randi_range(0,2)
		_max_stats += 1
	new_agent.strenght = array_stats[0]
	new_agent.harisma = array_stats[1]
	new_agent.agility = array_stats[2]
	new_agent.endurance = array_stats[3]
	new_agent.intellect = array_stats[4]
	current_agent = new_agent
	
func show_sprite(agent: AgentStats):
	agent_sprite.texture = agent.sprite
	agent_name.text = agent.agent_first_name + " " + agent.agent_second_name + " " + agent.agent_last_name
	set_agent_stats(current_agent)
func set_agent_stats(agent: AgentStats):
	var y_3 = 420 + agent.agility * 10
	var x_3 = 724 + (64 * float(agent.agility * 10) / 100)
	var third_point = Vector2(x_3, y_3)
	var y_4 = 420 + agent.endurance * 10
	var x_4 = 724 - (64 * float(agent.endurance * 10) / 100)
	var four_point = Vector2(x_4, y_4)
	var vertices = PackedVector2Array([Vector2(724 - agent.strenght*10, 420),Vector2(724, 420 - agent.intellect * 10), Vector2(724 + agent.harisma * 10, 420), third_point, four_point])
	pentastats.polygon = vertices
	print(pentastats.polygon)
	str_stat.text = str(agent.strenght)
	int_stat.text = str(agent.intellect)
	endur_stat.text = str(agent.endurance)
	agi_stat.text = str(agent.agility)
	har_stat.text = str(agent.harisma)
	
func load_sprites():
	var dir = DirAccess.open(sprites_folder)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "" and file_name != null:
			if file_name.ends_with(".png"):
				var texture = load(sprites_folder + file_name)
				if texture:
					available_sprites.append(texture)
			file_name = dir.get_next()
		dir.list_dir_end()

func pick_random_sprite(agent: AgentStats):
	var random_index = randi() % available_sprites.size()
	agent.sprite = available_sprites[random_index]
	return agent

func pick_random_name(agent: AgentStats):
	var _array_names: Array[String]
	var _array_second_names: Array[String]
	var _array_patronymics_names: Array[String]
	if agent.gender:
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
		agent.agent_first_name = _array_names.pick_random()
		agent.agent_second_name = _array_second_names.pick_random()
		agent.agent_last_name = _array_patronymics_names.pick_random()
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
		agent.agent_first_name = _array_names.pick_random()
		agent.agent_second_name = _array_second_names.pick_random()
		agent.agent_last_name = _array_patronymics_names.pick_random()
