extends CharacterBody2D

class_name Player

@export var speed = 300
@export var player_id : int
@export var held_item : Item

var facing_direction = FacingDirection.DOWN
var input_vector = Vector2.ZERO

enum FacingDirection {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

func _process(_delta) -> void:
	match input_vector:
		Vector2(0,1): facing_direction = FacingDirection.DOWN
		Vector2(0,-1): facing_direction = FacingDirection.UP
		Vector2(-1,0): facing_direction = FacingDirection.LEFT
		Vector2(1,0): facing_direction = FacingDirection.RIGHT
		
	match facing_direction:
		FacingDirection.RIGHT:
			$HandHitbox.global_position = global_position + Vector2(35, 0)
			if player_id == 0: set_player_texture(Vector2(256, 0))
			elif player_id == 1: set_player_texture(Vector2(256, 64))
		FacingDirection.LEFT:
			$HandHitbox.global_position = global_position + Vector2(-35, 0)
			if player_id == 0: set_player_texture(Vector2(320, 0))
			elif player_id == 1: set_player_texture(Vector2(320, 64))
		FacingDirection.UP:
			$HandHitbox.global_position = global_position + Vector2(0, -45)
			if player_id == 0: set_player_texture(Vector2(384, 0))
			elif player_id == 1: set_player_texture(Vector2(384, 64))
		FacingDirection.DOWN:
			$HandHitbox.global_position = global_position + Vector2(0, 45)
			if player_id == 0: set_player_texture(Vector2(192, 0))
			elif player_id == 1: set_player_texture(Vector2(192, 64))

func _physics_process(_delta) -> void:
	
	if player_id == 0:
		input_vector.x = Input.get_action_strength("key_d") - Input.get_action_strength("key_a")
		input_vector.y = Input.get_action_strength("key_s") - Input.get_action_strength("key_w")
		input_vector = input_vector.normalized()
	elif player_id == 1:
		input_vector.x = Input.get_action_strength("key_l") - Input.get_action_strength("key_j")
		input_vector.y = Input.get_action_strength("key_k") - Input.get_action_strength("key_i")
		
		input_vector = input_vector.normalized()
	else:
		push_error("Player index set out of bounds")
	
	if input_vector:
		velocity = input_vector * speed
		move_and_slide()

func set_player_texture(coordinates: Vector2) -> void:
	$PlayerSprite.texture.region = Rect2(coordinates, Vector2(64,64))
