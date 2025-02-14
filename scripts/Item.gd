extends Node

class_name Item

@export var item_id : Globals.ItemID
@export var item_name : String
@export var spritesheet : Texture
@export var processed : bool
@export var element : Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_element()
	update_item_icon()

func update_item_icon() -> void:
	match item_id:
		Globals.ItemID.NONE:
			set_item_icon(Rect2(Vector2(256,128), Vector2(64,64)))
			set_item_name("None")
		Globals.ItemID.LAVENDER_OIL:
			get_sprite_and_name(1, "Lavender Oil")
		Globals.ItemID.DRAGON_SCALES:
			get_sprite_and_name(2, "Dragon Scales")
		Globals.ItemID.LUNAR_SHARDS:
			get_sprite_and_name(3, "Lunar Shards")
		Globals.ItemID.SNAKE_VENOM:
			get_sprite_and_name(4, "Snake Venom")
		Globals.ItemID.GINGER_ROOT:
			get_sprite_and_name(5, "Ginger Root")
		Globals.ItemID.COCHINEAL_BASE: 
			get_sprite_and_name(6, "Cochineal Base")
		Globals.ItemID.MOLTEN_HEART:
			get_sprite_and_name(7, "Molten Heart")
		Globals.ItemID.STAR_SAPPHIRE:
			get_sprite_and_name(8, "Star Sapphire")
		Globals.ItemID.GOLDEN_TOURMALINE:
			get_sprite_and_name(9, "Golden Tourmaline")
		Globals.ItemID.SILENT_ROSE:
			get_sprite_and_name(10, "Silent Rose")
		Globals.ItemID.LIZARDS_TAIL:
			get_sprite_and_name(11, "Lizard's Tail")
		Globals.ItemID.POTION:
			match element[0]:
				Globals.ElementalType.FIRE:
					set_item_icon(Rect2(Vector2(832, 192), Vector2(64,64)))
					set_item_name("Fire Potion")
				Globals.ElementalType.ELECTRIC:
					set_item_icon(Rect2(Vector2(960, 192), Vector2(64,64)))
					set_item_name("Electric Potion")
				Globals.ElementalType.WATER:
					set_item_icon(Rect2(Vector2(896, 192), Vector2(64,64)))
					set_item_name("Water Potion")
				Globals.ElementalType.WIND:
					set_item_icon(Rect2(Vector2(1024, 192), Vector2(64,64)))
					set_item_name("Wind Potion")
				Globals.ElementalType.EARTH:
					set_item_icon(Rect2(Vector2(1088, 192), Vector2(64,64)))
					set_item_name("Earth Potion")
				_:
					set_item_icon(Rect2(Vector2(1024, 192), Vector2(64,64)))
					set_item_name("Void Potion")
		_:
			set_item_icon(Rect2(Vector2(0,0), Vector2(0,0)))
	
	if item_id != Globals.ItemID.POTION: update_element()

func get_sprite_and_name(sprite_num: float, new_item_name: String):
	var x = 448 + (64 * (sprite_num - 1))
	if !processed: set_item_icon(Rect2(Vector2(x, 0), Vector2(64,64)))
	if processed: set_item_icon(Rect2(Vector2(x, 64), Vector2(64,64)))
	set_item_name(new_item_name)

func set_item_icon(region: Rect2) -> void:
	var atlas = AtlasTexture.new()
	atlas.atlas = spritesheet
	atlas.region = region
	$ItemSprite.texture = atlas
	
func set_item_name(n: String) -> void:
	item_name = n
	
func set_item_id(id: Globals.ItemID) -> void:
	if item_id != id:
		item_id = id
		update_item_icon()
		
func set_elemental_type(primary: Globals.ElementalType, secondary: Globals.ElementalType):
	self.element = []
	self.element.append(primary)
	self.element.append(secondary)
	update_item_icon()

func set_processed_status(status: bool) -> void:
	if processed != status:
		processed = status
		update_item_icon()
		
func update_element():
	match item_id:
		Globals.ItemID.MOLTEN_HEART:
			element = [Globals.ElementalType.FIRE] 
		Globals.ItemID.GOLDEN_TOURMALINE:
			element = [Globals.ElementalType.ELECTRIC]
		Globals.ItemID.STAR_SAPPHIRE:
			element = [Globals.ElementalType.WATER]
		Globals.ItemID.SILENT_ROSE:
			element = [Globals.ElementalType.WIND]
		Globals.ItemID.LIZARDS_TAIL:
			element = [Globals.ElementalType.EARTH]
		_:
			element = [Globals.ElementalType.VOID]
