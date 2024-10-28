extends Node3D

@onready var fire_particles: GPUParticles3D = $FireParticles
var is_ablaze = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if body.velocity.length() > 10.0 and body.is_ablaze:
			body.is_ablaze = false
			fire_particles.emitting = true
			is_ablaze = true
