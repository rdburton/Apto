extends Node3D

var rotation_speed := 2.5
var player : Player
var rotation_in_degrees := 90.0
var target_rotation := 0.0
var current_rotation := 0.0

func _ready() -> void:
	player = get_parent()

func _process(delta: float) -> void:
	rotate_camera(delta)
	if rotation.y > 6.28:
		rotation.y = 0
	
func rotate_camera(delta: float) -> void:
	if player.rotate_camera:
		target_rotation += deg_to_rad(rotation_in_degrees)
		target_rotation = fmod(target_rotation, PI * 2)
		player.rotate_camera = false
		player.handle_animations()  # Call to update animations immediately upon rotation

	current_rotation = lerp_angle(current_rotation, target_rotation, rotation_speed * delta)
	rotation.y = current_rotation
	
