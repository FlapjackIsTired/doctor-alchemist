extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.max_value = get_timer().wait_time + 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !get_timer().is_stopped():
		self.value += delta
		self.visible = true
	elif get_timer().is_stopped():
		self.value = 0
		self.visible = false

func get_timer() -> Timer: return get_node("../Logic/Timer")
