extends Area2D

signal interact_started(player_id: int, interactable_id: int)
signal interact_ended(player_id: int, interactable_id: int)

@export var item_id: Globals.ItemID
@export var interactable_id: int
@export var interactable_type: Globals.InteractableType

func _ready() -> void:
	interactable_id = Globals.current_interactable_id
	Globals.current_interactable_id += 1

	match interactable_type:
		Globals.InteractableType.CRATE:
			get_node("./Item").set_item_id(item_id)

	if self is Area2D:
		connect("area_entered", _area_entered)
		connect("area_exited", _area_exited)
	else:
		push_error("Node Is Of Wrong Type")

func _area_entered(area: Area2D) -> void:
	if area.is_in_group("player_hands_one"):
		emit_signal("interact_started", 0, interactable_id)
	if area.is_in_group("player_hands_two"):
		emit_signal("interact_started", 1, interactable_id)

func _area_exited(area: Area2D) -> void:
	if area.is_in_group("player_hands_one"):
		emit_signal("interact_ended", 0, interactable_id)
	if area.is_in_group("player_hands_two"):
		emit_signal("interact_ended", 1, interactable_id)
