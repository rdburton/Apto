extends Area3D

@export var block_name : String = ""
var is_within := false
var area_center : Vector3

func _ready() -> void:
	area_center = global_position
	
func _physics_process(delta: float) -> void:
	if is_within:
		for body in get_overlapping_bodies():
			if body is RigidBody3D and body.is_in_group("PushBlock") and body.block_name == block_name:
				body.global_position.y = body.global_position.y
				body.global_position = lerp(body.global_position, area_center, 0.05)
				body.global_position.y = body.global_position.y
				
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("PushBlock"):
		if body.block_name == block_name:
			is_within = true	
			
