extends Node

enum ElementalType {
	FIRE,
	ELECTRIC,
	WATER,
	EARTH,
	WIND,
	VOID
}

enum ItemID {
	NONE,
	
	LAVENDER_OIL,
	GINGER_ROOT,
	DRAGON_SCALES,
	SNAKE_VENOM,
	COCHINEAL_BASE,
	LUNAR_SHARDS,
	
	MOLTEN_HEART,
	GOLDEN_TOURMALINE,
	STAR_SAPPHIRE,
	SILENT_ROSE,
	LIZARDS_TAIL,
	
	POTION,
}

enum InteractableType {
	PLATE,
	CRATE,
	GARBAGE_CRATE,
	GRINDER,
	DISTILLERY,
	ENERGY_EXTRACTOR,
	CAULDRON,
	REGISTER,
}

var current_interactable_id = 0
var none_item : Item

var itemTotals = {
	ItemID.LAVENDER_OIL: 99,
	ItemID.GINGER_ROOT: 99,
	ItemID.DRAGON_SCALES: 99,
	ItemID.SNAKE_VENOM: 99,
	ItemID.COCHINEAL_BASE: 99,
	ItemID.LUNAR_SHARDS: 99,
	
	ItemID.MOLTEN_HEART: 99,
	ItemID.GOLDEN_TOURMALINE: 99,
	ItemID.STAR_SAPPHIRE: 99,
	ItemID.SILENT_ROSE: 99,
	ItemID.LIZARDS_TAIL: 99,
}

#creates the day counter
var day = 1

#allows the day to change
var day_incremented = false


"""
0 - Player 1
1 - Player 2
doing it like this just in case the equivalent of potions{player_id} is necessary - B
"""
#for statistics

var potions0 = 0
var potions1 = 0
var slimes0 = 0
var slimes1 = 0
var thrown0 = 0
var thrown1 = 0

func ready():
	none_item = Item.new()
	none_item.set_item_id(ItemID.NONE)
	none_item.set_item_icon(Rect2(Vector2(256,128), Vector2(64,64)))
	none_item.set_item_name("None")
