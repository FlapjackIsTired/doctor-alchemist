extends Node

signal grinder_started(player_id, interactable_id, item)
signal grinder_finished(player_id, interactable_id, item)

var player : int
var interactable : int

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player_interaction")
	for node in players:
		node.connect("player_interacted", _on_player_interacted)
	$Timer.connect("timeout", _on_timer_timeout)
	
func _on_player_interacted(player_id: int, interactable_id: int, item: Item, element) -> void:
	# booleans to simplify if statements
	var interactable_is_correct = get_grinder().interactable_id == interactable_id
	var player_item_is_some = item.item_id != Globals.ItemID.NONE
	var item_is_none = get_node("../Item").item_id == Globals.ItemID.NONE
	var item_is_processed = get_node("../Item").processed
	var item_is_compatible = item.item_id == Globals.ItemID.COCHINEAL_BASE \
						  || item.item_id == Globals.ItemID.GINGER_ROOT \
						  || item.item_id == Globals.ItemID.DRAGON_SCALES \
						  || item.item_id == Globals.ItemID.LUNAR_SHARDS \
						  || item.item_id == Globals.ItemID.NONE
	
	# don't take in already processed materials
	if item.processed: return
	if item_is_compatible:
		# start the grinder if the timer is stopped and the grinder has no item
		if interactable_is_correct && $Timer.is_stopped() && item_is_none && player_item_is_some:
			emit_signal("grinder_started", player_id, interactable_id, get_node("../Item").duplicate(), get_node("../Item").element)
			$Timer.start()
			var old_item = get_node("../Item")
			handle_item_change(old_item, item)
		# finish the grinder if the timer has stopped and the item is processed
		elif interactable_is_correct && $Timer.is_stopped() && item_is_processed:
			var old_item = get_node("../Item")
			emit_signal("grinder_finished", player_id, interactable_id, old_item.duplicate(), old_item.element)
			handle_item_change(old_item, item)
		# in all other cases don't allow the player to interact
		else:
			return
	else:
		return

func get_grinder() -> Area2D:
	var grinder = get_parent()
	if is_instance_valid(grinder):
		return grinder
	else:
		printerr("GrinderLogic doesn't have a valid parent node")
		return null

func _on_timer_timeout() -> void:
	var old_item = get_node("../Item")
	old_item.set_processed_status(true)
	
func handle_item_change(old_item: Item, new_item: Item):
		var index = old_item.get_index()
		get_grinder().remove_child(old_item)
		old_item.queue_free()
		
		# set-up new item
		new_item.name = "Item"
		get_grinder().add_child(new_item)
		get_grinder().move_child(new_item, index)
