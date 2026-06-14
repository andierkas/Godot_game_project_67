extends Resource
class_name QuestVariant

@export var text: String

# Статы (максимум 10 по каждому)
@export var strenght: int
@export var harisma: int
@export var endurance: int
@export var intellect: int
@export var agility: int

# Награда за успех
@export var reward_xp: int

# ️последствия провала
@export var failure_damage: int = 0  # Урон игроку (PlayerStats) при провале
@export var failure_text: String = ""  # Описание что произошло (для UI)
