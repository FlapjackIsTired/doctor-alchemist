extends Node

signal cauldron_started(player_id, interactable_id, item)
signal cauldron_finished(player_id, interactable_id, item)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player_interaction")
	for node in players:
		node.connect("player_interacted", _on_player_interacted)
	$Timer.connect("timeout", _on_timer_timeout)

func _on_player_interacted(player_id, interactable_id, item):
	var interactable_is_correct = get_cauldron().interactable_id == interactable_id
	var _cauldron_inputs = get_node("../InputItems").get_children() # For DEBUG purposes
	
	if interactable_is_correct: pass
	else: return
	print("Player " + str(player_id) + " interacted with cauldron")
	
	if not item.processed: return
	if not output_is_some: pass

func _on_timer_timeout():
	var output_item = get_node("../OutputItem")
	var primary_type = get_node("../InputItems/Item1").element[0]
	var secondary_type = get_node("../InputItems/Item2").element[0]
	output_item.item_id = Globals.ItemID.POTION
	output_item.set_elemental_type(primary_type, secondary_type)
	
	var first_item = get_node("../InputItems/Item1")
	get_node("../InputItems").remove_child(first_item)
	first_item.queue_free()
	
	var second_item = get_node("../InputItems/Item2")
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
