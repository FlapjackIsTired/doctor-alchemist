extends Node

signal cauldron_started(player_id, interactable_id, item)
signal cauldron_finished(player_id, interactable_id, item)
signal show_caul_inv()
signal hide_caul_inv()

var storage = 0
var output_item 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var output_item = $"../OutputItem"
	var players = get_tree().get_nodes_in_group("player_interaction")
	for node in players:
		node.connect("player_interacted", _on_player_interacted)
	$Timer.connect("timeout", _on_timer_timeout)

func _on_player_interacted(player_id, interactable_id, item):
	
	var interactable_is_correct = get_cauldron().interactable_id == interactable_id
	
	#all input items are valid
	#var _cauldron_inputs = get_node("../InputItems").get_children() # For DEBUG purposes
	output_item = $"../OutputItem"
	if $Timer.is_stopped() and output_item.item_id == Globals.ItemID.NONE:
		if interactable_is_correct and $Timer.is_stopped() and storage < 2:
		
			#item becomes child node of InputItems
			add_input_item(item)
			storage += 1
			emit_signal("show_caul_inv")
		
		#this thing isn't connected. I'm unsure where garbage_clicked originates atm..
		#if I have time tmmrow I'll trace with debugging
			#emit_signal("garbage_clicked",player_id, interactable_id, item)
		
		if interactable_is_correct and $Timer.is_stopped() and storage == 2:
		
			#item becomes child node of InputItems
			add_input_item(item)
			storage = 0
			emit_signal("hide_caul_inv")
			$Timer.start()
		else: return
		print("Player " + str(player_id) + " interacted with cauldron")
		if not item.processed: return
		if not output_is_some: pass
	if $Timer.is_stopped() and output_item.item_id == Globals.ItemID.POTION:
		print("About to chang ed")
		var old_item = get_node("../OutputItem")
		emit_signal("cauldron_finished", player_id, interactable_id, old_item.duplicate())
		handle_item_change(old_item, item)

	#elif $"../OutputItem".item_id == Globals.ItemID.POTION and $Timer.is_stopped() and storage == 0:
		#print("Player " + str(player_id) + " interacted with potion")
		#var player_item = get_node("Player1/HandHitbox/Item")
		#player_item.item_id = $"../OutputItem".item_id
		#$"../OutputItem".item_id = Globals.ItemID.NONE
	
func _on_timer_timeout():
	var output_item = get_node("../OutputItem")
	var primary_type = get_node("../InputItems/Item1").element[0]
	#print(primary_type)
	var secondary_type = get_node("../InputItems/Item3").element[0]
	#print(secondary_type)
	output_item.item_id = Globals.ItemID.POTION
	output_item.set_elemental_type(primary_type, secondary_type)
	#print(output_item.item_id, output_item.element)
	#print(output_item.item_name)
	
	#var old_item = get_node("../Item")
	#old_item.set_processed_status(true)
	
	var first_item = get_node("../InputItems/Item1")
	get_node("../InputItems").remove_child(first_item)
	first_item.queue_free()
	
	var second_item = get_node("../InputItems/Item3")
	get_node("../InputItems").remove_child(second_item)
	second_item.queue_free()
	
func output_is_some(node_path: String) -> bool:
	var node : Item = get_node(node_path)
	if node.element == [Globals.ElementalType.VOID]:
		return false
	else:
		return true

func add_input_item(item: Item):
	var index = 0
	item.name = "Item" + str(get_node("../InputItems").get_child_count() + 1)
	get_node("../InputItems").add_child(item)
	get_node("../InputItems").move_child(item, index)
	
func get_cauldron():
	var grinder = get_parent()
	if is_instance_valid(grinder):
		return grinder
	else:
		printerr("GrinderLogic doesn't have a valid parent node")
		return null
		
func handle_item_change(old_item: Item, new_item: Item):
		var index = old_item.get_index()
		#get_cauldron().remove_child(old_item)
		#old_item.queue_free()
		
		# set-up new item
		new_item.name = "OutputItem"
		get_cauldron().add_child(new_item)
		get_cauldron().move_child(new_item, index)
		output_item.item_id = Globals.ItemID.NONE
		output_item.update_item_icon()
		print("Item hath been chang ed ")
