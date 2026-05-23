extends Node2D

@onready var genderage = $Gender_age
@onready var aspect = $Aspect
@onready var nameagent = $NameAgent
@onready var sprite = $SpriteAgent

@export var agent: AgentStats

func _ready() -> void:
	await get_tree().process_frame  # Ждём один кадр
	var parent = get_parent()
	agent = parent.get("current_agent")
	updateagent(agent)

func updateagent(agent: AgentStats):
	if agent.gender == true:
		genderage.text = "Male," + " " + str(agent.age)
	else:
		genderage.text = "Female," + " " + str(agent.age)
	#aspect.text = agent.aspect
	nameagent.text = agent.agent_second_name + " " + agent.agent_first_name + " " + agent.agent_last_name
	sprite.texture = agent.sprite
	$FillPentagonStats.update(agent)
