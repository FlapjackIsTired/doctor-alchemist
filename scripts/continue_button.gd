extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/DayOverMenu/TextureRect/Bottom-CenterCont/ContinueButton").text = "Continue to day {0}".format([Globals.day])


#runs when button is clicked
func _on_pressed():
	
	#allows the day to change
	Globals.day_incremented = false
	
	#resets the statistics
	Globals.potions0 = 0
	Globals.potions1 = 0
	Globals.slimes0 = 0
	Globals.slimes1 = 0
	Globals.thrown0 = 0
	Globals.thrown1 = 0
	
	
	#returns to the kitchen
	TransitionScreen.transition("res://scenes/world.tscn")
