extends Node3D

@export_file ("*.tscn") var next_level

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.complete_level(next_level)
