extends Label


# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event.is_action("debug_menu"):
		visible = !self.visible


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.text = str(Engine.get_frames_per_second())
 
