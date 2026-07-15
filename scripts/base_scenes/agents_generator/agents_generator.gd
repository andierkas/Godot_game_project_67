extends Control

@onready var labelIntellect = $Current_agent/StringStats/Intellect
@onready var labelIntellectStat = $Current_agent/FillPentagonStats/IntellectStat
@onready var labelStrenght = $Current_agent/StringStats/Strenght
@onready var labelStrenghtStat = $Current_agent/FillPentagonStats/StrenghtStat
@onready var labelHarisma = $Current_agent/StringStats/Harisma
@onready var labelHarismaStat = $Current_agent/FillPentagonStats/HarismaStat
@onready var labelEndurance = $Current_agent/StringStats/Endurance
@onready var labelEnduranceStat = $Current_agent/FillPentagonStats/EnduranceStat
@onready var labelAgility = $Current_agent/StringStats/Agility
@onready var labelAgilityStat = $Current_agent/FillPentagonStats/AgilityStat

@onready var agent_1 = $Agentparty/dragbox/Panel/Agent
@onready var agent_2 = $Agentparty/dragbox/Panel2/Agent
@onready var agent_3 = $Agentparty/dragbox/Panel3/Agent
@onready var agent_4 = $Agentparty/dragbox/Panel4/Agent
@onready var agent_5 = $Agentparty/dragbox/Panel5/Agent
@onready var animScreen = $Current_agent/AnimScreen


@export var current_agent: AgentStats

func _ready():
	animScreen.play("screen_animation")
	current_agent = agent_1.agent

func _on_button_2_pressed() -> void:
	get_tree().reload_current_scene()

func _on_back_button_pressed() -> void:
	SceneLoader.load_scene("res://all_scenes/base_scenes/loadgame_scene.tscn")


func _on_next_pressed() -> void:
	PartyBox.add_agent(agent_1.agent)
	PartyBox.add_agent(agent_2.agent)
	PartyBox.add_agent(agent_3.agent)
	SceneLoader.load_scene("res://all_scenes/base_scenes/gameplay_scene.tscn")
	
func _on_intellect_mouse_entered() -> void:
	labelIntellectStat.add_theme_color_override("font_color", Color("000000ff"))

func _on_intellect_mouse_exited() -> void:
	labelIntellectStat.add_theme_color_override("font_color", Color.WHITE)


func _on_endurance_mouse_entered() -> void:
	labelEnduranceStat.add_theme_color_override("font_color", Color("000000ff"))

func _on_endurance_mouse_exited() -> void:
	labelEnduranceStat.add_theme_color_override("font_color", Color.WHITE)


func _on_strenght_mouse_entered() -> void:
	labelStrenghtStat.add_theme_color_override("font_color", Color("000000ff"))

func _on_strenght_mouse_exited() -> void:
	labelStrenghtStat.add_theme_color_override("font_color", Color.WHITE)


func _on_harisma_mouse_entered() -> void:
	labelHarismaStat.add_theme_color_override("font_color", Color("000000ff"))

func _on_harisma_mouse_exited() -> void:
	labelHarismaStat.add_theme_color_override("font_color", Color.WHITE)


func _on_agility_mouse_entered() -> void:
	labelAgilityStat.add_theme_color_override("font_color", Color("000000ff"))

func _on_agility_mouse_exited() -> void:
	labelAgilityStat.add_theme_color_override("font_color", Color.WHITE)
