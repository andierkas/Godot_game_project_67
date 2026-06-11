extends CharacterBody2D

const TEAM_SPRITE = preload("res://materials/1781209134 1 (1).png")

@export var speed: float = 200.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: Sprite2D = $Sprite2D

# Функция инициализации отряда
func setup(agents: Array, target_pos: Vector2) -> void:
	var agents_count = agents.size()
	
	# Выбираем спрайт в зависимости от количества агентов
	if agents_count == 1:
		# Одиночный агент - используем его личный спрайт из AgentStats
		sprite.texture = agents[0].sprite
	else:
		# Группа 2+ человек - используем командный спрайт
		sprite.texture = TEAM_SPRITE
	
	# Устанавливаем цель для навигации
	navigation_agent.set_target_position(target_pos)

func _physics_process(delta: float) -> void:
	# Проверяем, достигли ли цели
	if navigation_agent.is_target_reached():
		velocity = Vector2.ZERO
		return
	
	# Получаем следующую точку пути
	var next_path_position = navigation_agent.get_next_path_position()
	
	# Вычисляем направление к следующей точке
	var direction = global_position.direction_to(next_path_position)
	
	# Устанавливаем скорость
	velocity = direction * speed
	
	# Двигаем отряд
	move_and_slide()
