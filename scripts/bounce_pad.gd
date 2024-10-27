extends Node3D

@export var bounce_power := 50.0
var is_within = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		is_within = true
		body.is_bouncing = true
		body.velocity.y += bounce_power


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		is_within = false
