extends Node3D

@export var bounce_power := 50.0

@onready var water_particles: GPUParticles3D = $WaterParticles

var is_within = false
var has_reset = true
var activated = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and has_reset:
		if body.is_water:
			activated = true

		if activated:
			water_particles.emitting = true
			is_within = true
			body.is_bouncing = true
			body.velocity.y = 0.0
			body.velocity.y += bounce_power
			has_reset = false
		else:
			pass


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		is_within = false
		await get_tree().create_timer(3).timeout
		water_particles.emitting = false
		has_reset = true
