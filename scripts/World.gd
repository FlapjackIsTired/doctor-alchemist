extends Node2D

func _ready() -> void:
	
	get_node("Player1/HandHitbox").add_to_group("player_hands_one")	
	get_node("Player2/HandHitbox").add_to_group("player_hands_two")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass
