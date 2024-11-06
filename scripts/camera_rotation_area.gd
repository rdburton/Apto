extends Node3D

@export var should_rotate := false
@export var first_rotation := 90.0
@export var second_rotation := 0.0
@export var rotation_speed := 2.5
var player : Player
var current_rotation : float
var camera_pivot_sc 

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	camera_pivot_sc = player.get_child(0)
	current_rotation = first_rotation
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if should_rotate:
			camera_pivot_sc.rotation_speed = rotation_speed
			player.rotate_camera = true
			camera_pivot_sc.rotation_in_degrees = current_rotation
		else:
			player.rotate_camera = false


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if current_rotation == first_rotation:
			current_rotation = second_rotation
		elif current_rotation == second_rotation:
			current_rotation = first_rotation
		else:
			current_rotation = first_rotation
