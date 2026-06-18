extends Control

var current_agent: AgentStats = null

# UI элементы
@onready var sprite: Sprite2D = $Sprite2D
@onready var agent_name: Label = $AgentName
@onready var xp_label: Label = $XP
@onready var max_xp_bar: ColorRect = $max_xp
@onready var current_xp_bar: ColorRect = $current_xp
@onready var polygon_agent: Polygon2D = $max_polygon/polygon_agent

# Значения статов
@onready var strenght_value: Label = $VBoxContainer2/strenght_value
@onready var harisma_value: Label = $VBoxContainer2/harisma_value
@onready var endurance_value: Label = $VBoxContainer2/endurance_value
@onready var intellect_value: Label = $VBoxContainer2/intellect_value
@onready var agility_value: Label = $VBoxContainer2/agility_value

# Контейнер и кнопки прокачки
@onready var stats_buttons_container: VBoxContainer = $VBoxContainer3
@onready var strenght_button: Button = $VBoxContainer3/Button
@onready var harisma_button: Button = $VBoxContainer3/Button2
@onready var endurance_button: Button = $VBoxContainer3/Button3
@onready var intellect_button: Button = $VBoxContainer3/Button4
@onready var agility_button: Button = $VBoxContainer3/Button5

func _ready() -> void:
	# Подключаем кнопки прокачки
	strenght_button.pressed.connect(_on_stat_button_pressed.bind("strenght"))
	harisma_button.pressed.connect(_on_stat_button_pressed.bind("harisma"))
	endurance_button.pressed.connect(_on_stat_button_pressed.bind("endurance"))
	intellect_button.pressed.connect(_on_stat_button_pressed.bind("intellect"))
	agility_button.pressed.connect(_on_stat_button_pressed.bind("agility"))
	
	# Скрываем профиль и кнопки при запуске
	visible = false
	stats_buttons_container.visible = false
	print("🟢 AgentProfile загружен")

# Функция для кнопки закрытия
func _on_button_pressed() -> void:
	$".".hide()
	current_agent = null

# Открыть профиль агента
func open_profile(agent: AgentStats) -> void:
	current_agent = agent
	$".".show()
	print("📋 Открыт профиль: ", agent.get_full_name())
	print(" Skillpoints: ", agent.skill_points)
	_update_ui()

# Обновить весь UI
func _update_ui() -> void:
	if not current_agent:
		return
	
	# Спрайт агента
	if current_agent.sprite:
		sprite.texture = current_agent.sprite
	
	# Имя агента
	agent_name.text = current_agent.get_full_name()
	
	# XP в формате "текущий/необходимый"
	var xp_to_next = current_agent.get_xp_to_next_level()
	xp_label.text = str(current_agent.xp) + "/" + str(xp_to_next)
	
	# Ширина current_xp: 1% = 34.4 пикселя, 100% = 344 пикселя
	var xp_percent = float(current_agent.xp) / float(xp_to_next) * 100.0
	var xp_width = xp_percent * 3.44
	current_xp_bar.size.x = clamp(xp_width, 0, 344)
	
	
	polygon_agent.polygon = _generate_pentagon_vertices(current_agent)
	
	# Значения статов
	strenght_value.text = str(current_agent.strenght)
	harisma_value.text = str(current_agent.harisma)
	endurance_value.text = str(current_agent.endurance)
	intellect_value.text = str(current_agent.intellect)
	agility_value.text = str(current_agent.agility)
	
	# Показываем/скрываем и обновляем кнопки прокачки
	_update_buttons()

# Обновить доступность кнопок прокачки
func _update_buttons() -> void:
	var has_points = current_agent.skill_points > 0
	
	# Показываем контейнер только если есть skillpoints
	stats_buttons_container.visible = has_points
	
	if has_points:
		# Отключаем кнопку, если стат уже на максимуме (10)
		strenght_button.disabled = current_agent.strenght >= 10
		harisma_button.disabled = current_agent.harisma >= 10
		endurance_button.disabled = current_agent.endurance >= 10
		intellect_button.disabled = current_agent.intellect >= 10
		agility_button.disabled = current_agent.agility >= 10
	else:
		# Если очков нет, отключаем все кнопки
		strenght_button.disabled = true
		harisma_button.disabled = true
		endurance_button.disabled = true
		intellect_button.disabled = true
		agility_button.disabled = true

# Нажатие на кнопку прокачки стата
func _on_stat_button_pressed(stat_name: String) -> void:
	if not current_agent:
		return
	
	# ДВОЙНАЯ ПРОВЕРКА: Максимум 10
	if current_agent.get(stat_name) >= 10:
		print("️ Стат ", stat_name, " уже на максимуме (10)!")
		return
	
	if current_agent.skill_points <= 0:
		print("⚠️ Нет skillpoints!")
		return
	
	# Тратим skillpoint и повышаем стат
	current_agent.skill_points -= 1
	
	match stat_name:
		"strenght":
			current_agent.strenght += 1
			print("✅ Strenght повышен до ", current_agent.strenght)
		"harisma":
			current_agent.harisma += 1
			print("✅ Harisma повышен до ", current_agent.harisma)
		"endurance":
			current_agent.endurance += 1
			print("✅ Endurance повышен до ", current_agent.endurance)
		"intellect":
			current_agent.intellect += 1
			print("✅ Intellect повышен до ", current_agent.intellect)
		"agility":
			current_agent.agility += 1
			print("✅ Agility повышен до ", current_agent.agility)
	
	# Обновляем UI профиля
	_update_ui()
	
	# Обновляем UI слотов агентов на главном экране
	var grid = get_node_or_null("/root/Main/Panel/GridContainer")
	if grid and grid.has_method("refresh_all_slots"):
		grid.refresh_all_slots()

func _generate_pentagon_vertices(agent: AgentStats) -> PackedVector2Array:
	var y_3 = 0 + agent.agility * 10
	var x_3 = 0 + (64 * float(agent.agility * 10) / 100)
	var third_point = Vector2(x_3, y_3)
	
	var y_4 = 0 + agent.endurance * 10
	var x_4 = 0 - (64 * float(agent.endurance * 10) / 100)
	var four_point = Vector2(x_4, y_4)
	
	var vertices = PackedVector2Array([
		Vector2(0 - agent.strenght * 10, 0),       # Левый (Сила)
		Vector2(0, 0 - agent.intellect * 10),      # Верхний (Интеллект)
		Vector2(0 + agent.harisma * 10, 0),        # Правый (Харизма)
		third_point,                               # Нижний правый (Ловкость)
		four_point                                 # Нижний левый (Выносливость)
	])
	
	return vertices
