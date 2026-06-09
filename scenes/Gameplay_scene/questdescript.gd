extends Panel

@onready var sprite = $spritequest
@onready var namequest = $NameQuest
@onready var quest_desc = $descript

func show_quest(quest: Quest):
	namequest.text = quest.name
	quest_desc.text = quest.description
	sprite.texture = quest.slide
	show()


func _on_button_pressed() -> void:
	hide()
