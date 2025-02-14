extends Node

signal crate_opened(player_id, interactable_id, item)

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player_interaction")
	for node in players:
		node.connect("player_interacted", _on_player_interacted)

func _on_player_interacted(player_id: int, interactable_id: int, item: Item) -> void:
	# save old item
	var new_item = get_node("../Item")
	# make sure the correct plate is being edited
	if get_crate().interactable_id == interactable_id:
		# if the player isnt holding an item and there is stock of items, emit the crate_opened signal
		if (item.item_id == Globals.ItemID.NONE) && (Globals.itemTotals[new_item.item_id] > 0):
			emit_signal("crate_opened", player_id, interactable_id, new_item.duplicate())
			Globals.itemTotals[new_item.item_id] -= 1
		else: return
	else:
		return

func get_crate() -> Area2D:
	var crate = get_parent()
	if is_instance_valid(crate):
		return crate
	else:
		printerr("PlayerInteraction has no valid parent (Player node).")
		return null
