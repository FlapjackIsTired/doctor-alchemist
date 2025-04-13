extends Node

signal player_interacted(player_id, interactable_id, item, element)

var player_id : int
var interacting_with = {}

func _ready() -> void:
	# get all interactable nodes and connect their corresponding signals
	var interactables = get_tree().get_nodes_in_group("interactables")
	for node in interactables:
		node.connect("interact_started", _on_interact_started)
		node.connect("interact_ended", _on_interact_ended)
		# should expand with station types
		match node.interactable_type:
			Globals.InteractableType.PLATE:
				node.get_node("PlateLogic").connect("plate_full", _on_item_collected)
			Globals.InteractableType.CRATE:
				node.get_node("CrateLogic").connect("crate_opened", _on_item_collected)
			Globals.InteractableType.GARBAGE_CRATE:
				node.get_node("GarbageCrateLogic").connect("garbage_clicked", _on_item_collected)
			Globals.InteractableType.GRINDER:
				node.get_node("Logic").connect("grinder_started", _on_item_collected)
				node.get_node("Logic").connect("grinder_finished", _on_item_collected)
			Globals.InteractableType.DISTILLERY:
				node.get_node("Logic").connect("distillery_started", _on_item_collected)
				node.get_node("Logic").connect("distillery_finished", _on_item_collected)
			Globals.InteractableType.ENERGY_EXTRACTOR:
				node.get_node("Logic").connect("extractor_started", _on_item_collected)
				node.get_node("Logic").connect("extractor_finished", _on_item_collected)
			Globals.InteractableType.CAULDRON:
				node.get_node("Logic").connect("cauldron_started", _on_item_collected)
				node.get_node("Logic").connect("cauldron_finished", _on_item_collected)
			_:
				pass

func _input(event: InputEvent) -> void:
	# if the player presses the interact button while their hitbox is overlapping 
	# with one of the interactables send out a player interacted signal 
	var item = get_node("../HandHitbox/Item").duplicate()
	match player_id:
		0:
			if event.is_action_pressed("interact_player0") and interacting_with.has(player_id):
				for id in interacting_with[player_id]:
					emit_signal("player_interacted", player_id, id, item, item.element)
		1:
			if event.is_action_pressed("interact_player1") and interacting_with.has(player_id):
				for id in interacting_with[player_id]:
					emit_signal("player_interacted", player_id, id, item)


#region Signal Functions

func _on_interact_started(player: int, interactable: int) -> void:
	#
	if get_player().player_id == player:
		player_id = player
		# if the player id is not in the dictionary, add it as an empty entry
		if not interacting_with.has(player):
			interacting_with[player] = []
		# replace the players value in interacting_with with the interactable id
		interacting_with[player].append(interactable)
		#print("Player ", player+1, " started interacting with Interactable ", interactable)
	else:
		return

func _on_interact_ended(player: int, interactable: int) -> void:
	# if the player id is in the interaction array delete it's contents
	if interacting_with.has(player):
		if interactable in interacting_with[player]:
			interacting_with[player].erase(interactable)
			#print("Player ", player+1, " ended interacting with Interactable ", interactable)
	# if the player id is in the interaction array and is empty delete it
	if interacting_with.has(player) and interacting_with[player].is_empty():
		interacting_with.erase(player)

func _on_item_collected(id: int, _interactable_id: int, item: Item, element: Array):
	var old_item = get_node("../HandHitbox/Item")
	if get_player().player_id == id:
		var index = old_item.get_index()
		get_hand_hitbox().remove_child(old_item)
		old_item.queue_free()
		print(item.item_name, " " , item.item_id)
		item.name = "Item"
		get_hand_hitbox().add_child(item)
		get_hand_hitbox().move_child(item, index)
		item.element = element
		if item.item_id == Globals.ItemID.NONE:
			item.processed = false
		get_node("../HandHitbox/Item").update_item_icon()

	
#endregion

#region Helper Functions

func get_player() -> CharacterBody2D:
	var player = get_parent()
	if is_instance_valid(player):
		return player
	else:
		printerr("PlayerInteraction has no valid parent (Player node).")
		return null

func get_hand_hitbox() -> Area2D:
	var hand_hitbox = get_node("../HandHitbox")
	if is_instance_valid(hand_hitbox):
		return hand_hitbox
	else:
		printerr("PlayerInteraction has no valid parent (Player node).")
		return null
#endregion
