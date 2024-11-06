extends Area3D

@export var zoom : bool = true
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.zoom_camera = zoom
		
#func _on_body_exited(body: Node3D) -> void:
	#if body.is_in_group("Player"):
		#body.zoom_camera = zoom
