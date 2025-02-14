extends Label

var item_type : Globals.ItemID

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_text()

func update_text():
	item_type = get_node("../Item").item_id
	self.text = str(Globals.itemTotals[item_type])

func get_crate() -> Area2D:
	var crate = get_parent()
	if is_instance_valid(crate):
		return crate
	else:
		printerr("PlayerInteraction has no valid parent (Player node).")
		return null
