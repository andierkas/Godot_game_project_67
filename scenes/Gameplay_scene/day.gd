extends Node

@onready var quest_marker = $questmark
@onready var quest_window = $Questdescript

func _ready() -> void:
	quest_marker.open_window_quest.connect(quest_window.show_quest)
	
