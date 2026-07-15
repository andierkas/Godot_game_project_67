extends Node2D

@onready var genderage = $Gender_age
#@onready var aspect = $Aspect
@onready var nameagent = $NameAgent
@onready var sprite = $SpriteAgent

@export var agent: AgentStats

func _ready() -> void:
	await get_tree().process_frame  # Ждём один кадр
	var parent = get_parent()
	agent = parent.get("current_agent")
	updateagent(agent)

func updateagent(_agent: AgentStats):
	if _agent.gender == true:
		genderage.text = "Male," + " " + str(_agent.age)
	else:
		genderage.text = "Female," + " " + str(_agent.age)
	#aspect.text = _agent.aspect
	nameagent.text = _agent.agent_second_name + " " + _agent.agent_first_name + " " + _agent.agent_last_name
	sprite.texture = _agent.sprite
	$FillPentagonStats.update(_agent)
