extends CharacterBody2D

const TEAM_SPRITE = preload("res://materials/1781209134 1 (1).png")

@export var speed: float = 100.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: Sprite2D = $Sprite2D

var agents: Array
var is_path_ready: bool = false  # ⬅️ Флаг, что путь построен

signal squad_arrived(agents: Array)

func setup(agents_array: Array, target_pos: Vector2) -> void:
	agents = agents_array
	var agents_count = agents.size()
	
	print("🔧 Squad.setup() вызван")
	print("👥 Агентов: ", agents_count)
	print("🎯 Цель: ", target_pos)
	
	if agents_count == 1:
		sprite.texture = agents[0].sprite
	else:
		sprite.texture = TEAM_SPRITE
	
	navigation_agent.set_target_position(target_pos)
	
	# ⬇️ Ждем один кадр, чтобы навигация успела построить путь
	await get_tree().process_frame
	is_path_ready = true
	print("✅ Навигация настроена, отряд должен двигаться")

func _physics_process(delta: float) -> void:
	# ️ Не даем сработать прибытию, пока путь не готов
	if not is_path_ready:
		return

	if navigation_agent.is_target_reached():
		velocity = Vector2.ZERO
		_on_arrived()
		return
	
	var next_path_position = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_position)
	velocity = direction * speed
	move_and_slide()

func _on_arrived() -> void:
	print("✅ Отряд прибыл! Агентов: ", agents.size())
	
	squad_arrived.emit(agents)
	
	queue_free()
