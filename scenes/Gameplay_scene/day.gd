extends Node

@onready var quest_marker = $questmark
@onready var quest_window = $Questdescript

func _ready() -> void:
	quest_marker.open_window_quest.connect(quest_window.show_quest)
	
	var nav_region = $NavigationRegion2D
	print("Cell Size: ", nav_region.cell_size)
	print("Geometry Mask: ", nav_region.geometry_mask)
	print("Parsed Geometry Type: ", nav_region.parsed_geometry_type)
