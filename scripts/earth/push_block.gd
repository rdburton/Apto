extends RigidBody3D

@export var block_name : String = ""

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		self.mass = 10.0

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		self.mass = 100.0
