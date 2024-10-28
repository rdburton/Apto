extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.is_ablaze = true
		
func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		await get_tree().create_timer(10).timeout
		body.is_ablaze = false
