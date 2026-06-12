extends GridContainer

@onready var agent1 = $TextureRect
@onready var agent2 = $TextureRect2
@onready var agent3 = $TextureRect3
@onready var agent4 = $TextureRect4
@onready var agent5 = $TextureRect5
@onready var agent6 = $TextureRect6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = PartyBox.get_agent(0).sprite
	atlas_texture.region = Rect2(550,20,300,250)
	agent1.texture = atlas_texture
	agent1.agent = PartyBox.get_agent(0)
	var atlas_texture_2 = AtlasTexture.new()
	atlas_texture_2.atlas = PartyBox.get_agent(1).sprite
	atlas_texture_2.region = Rect2(550,20,300,250)
	agent2.texture = atlas_texture_2
	agent2.agent = PartyBox.get_agent(1)
	var atlas_texture_3 = AtlasTexture.new()
	atlas_texture_3.atlas = PartyBox.get_agent(2).sprite
	atlas_texture_3.region = Rect2(550,20,300,250)
	agent3.texture = atlas_texture_3
	agent3.agent = PartyBox.get_agent(2)
