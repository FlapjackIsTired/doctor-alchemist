extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/DayOverMenu/TextureRect/Left-CenterCont/P1Info").text = """
	• Player 1 cured {0} slimes
	• Player 1 threw away {1} items
	• Player 1 made {2} potions
	""".format([Globals.slimes0,Globals.thrown0,Globals.potions0])
