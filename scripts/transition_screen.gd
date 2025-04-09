extends CanvasLayer


signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

var next_scene = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	
	#Checks whether the scene should fade in or fade out
	if anim_name == "fade_out":
		on_transition_finished.emit()
		get_tree().change_scene_to_file(next_scene)
		animation_player.play("fade_in")
	elif anim_name == "fade_in":
		color_rect.visible = false

func transition(scene):
	
	next_scene = scene
	#all transitions begin with a fade in
	color_rect.visible = true
	animation_player.play("fade_out")
