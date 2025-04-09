extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#stats for both players are added for this label.
	get_node("/root/DayOverMenu/TextureRect/CenterCont/BothInfo").text = """
	• You both cured {0} slimes
	• You both threw away {1} items
	• You both made {2} potions
	""".format([(Globals.slimes1+Globals.slimes0),(Globals.thrown1+Globals.thrown0),(Globals.potions1+Globals.potions0)])
