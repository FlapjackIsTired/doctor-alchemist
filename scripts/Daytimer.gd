extends Node



@onready var label = $"../DayTimer"
var time_left = 120.0


func _ready():
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.254902, 0.411765, 0.882353, 1)  #
	stylebox.border_color = Color(0, 0, 0, 1)  #Black
	stylebox.border_width_top = 2
	stylebox.border_width_bottom = 2
	stylebox.border_width_left = 2
	stylebox.border_width_right = 2
	set("theme_override_styles/normal", stylebox)  


func _process(delta):
	if time_left > 0:
		time_left -= delta
		
		#Godot variant of f-strings
		label.text = "Day {0} will end in {1} seconds.".format([Globals.day, int(ceil(time_left))])
	else:
		label.text = "The day is over."
		
		if Globals.day_incremented == false:
			Globals.day += 1
			Globals.day_incremented = true
		#fade transition begins
		TransitionScreen.transition("res://scenes/day_over_menu.tscn")
