extends Resource
class_name AgentStats
# Статы
@export var strenght: int 
@export var harisma: int 
@export var endurance: int 
@export var intellect: int
@export var agility: int 

# ФИО
@export var agent_first_name: String
@export var agent_second_name: String
@export var agent_last_name: String

#Спрайты
@export var sprite: Texture2D
@export var portrait_region: Rect2 = Rect2(113,0,85,85)
var portrait: Texture2D

func generate_portrait():
	if not sprite:
		return
	
	portrait = extract_region(portrait_region)


func extract_region(region: Rect2) -> Texture2D:
	var image = sprite.get_image()
	var region_image = image.get_region(region)
	return ImageTexture.create_from_image(region_image)
