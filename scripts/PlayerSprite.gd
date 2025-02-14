extends Sprite2D

@export var spritesheet : Texture

func _ready():
	match get_parent().player_id:
		0:
			create_atlas_texture(Rect2(192, 0, 64, 64))
		1:
			create_atlas_texture(Rect2(192, 64, 64, 64))

func create_atlas_texture(region: Rect2):
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = spritesheet
	atlas_texture.region = region
	texture = atlas_texture
