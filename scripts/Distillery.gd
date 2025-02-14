extends Node

signal distillery_started(player_id, interactable_id, item)
signal distillery_finished(player_id, interactable_id, item)

var player : int
var interactable : int

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player_interaction")
	for node in players:
		node.connect("player_interacted", _on_player_interacted)
	$Timer.connect("timeout", _on_timer_timeout)
	
func _on_player_interacted(player_id: int, interactable_id: int, item: Item) -> void:
	# booleans to simplify if statements
	var interactable_is_correct = get_distillery().interactable_id == interactable_id
	var player_item_is_some = item.item_id != Globals.ItemID.NONE
	var item_is_none = get_node("../Item").item_id == Globals.ItemID.NONE
	var item_is_processed = get_node("../Item").processed
	var item_is_compatible = item.item_id == Globals.ItemID.LAVENDER_OIL \
						  || item.item_id == Globals.ItemID.SNAKE_VENOM \
						  || item.item_id == Globals.ItemID.NONE
	
	# don't take in already processed or no materials
	if item.processed: return
	if item_is_compatible:
		# start the grinder if the timer is stopped and the grinder has no item
		if interactable_is_correct && $Timer.is_stopped() && item_is_none && player_item_is_some:
			emit_signal("distillery_started", player_id, interactable_id, get_node("../Item").duplicate())
			$Timer.start()
			var old_item = get_node("../Item")
			handle_item_change(old_item, item)
		# finish the grinder if the timer has stopped and the item is processed
		elif interactable_is_correct && $Timer.is_stopped() && item_is_processed:
			var old_item = get_node("../Item")
			emit_signal("distillery_finished", player_id, interactable_id, old_item.duplicate())
			handle_item_change(old_item, item)
		# in all other cases don't allow the player to interact
		else:
			return
	else:
		return

func get_distillery() -> Area2D:
	var distillery = get_parent()
	if is_instance_valid(distillery):
		return distillery
	else:
		printerr("DistilleryLogic doesn't have a valid parent node")
		return null

func _on_timer_timeout() -> void:
	var old_item = get_node("../Item")
	old_item.set_processed_status(true)
	
func handle_item_change(old_item: Item, new_item: Item):
		var index = old_item.get_index()
		get_distillery().remove_child(old_item)
		old_item.queue_free()
		
		# set-up new item
		new_item.name = "Item"
		get_distillery().add_child(new_item)
		get_distillery().move_child(new_item, index)
