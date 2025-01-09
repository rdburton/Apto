extends Node3D

@export var blocks : Array[RigidBody3D]

var has_impacted := false

@onready var area_3d: Area3D = $Area3D
@onready var cloud_particle: GPUParticles3D = $CloudParticle

func _process(delta: float) -> void:
	if has_impacted:
		has_impacted = false
		await get_tree().create_timer(5).timeout
		_delete_blocks()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if body.is_earth and body.is_dashing:
			has_impacted = true
			#cloud_particle.emitting = true
			for block in blocks:
				var impact := Vector3(0, randf_range(1.0, 3.0), randf_range(-5.0, -12.0))
				var global_impact = block.global_basis * impact
				block.freeze = false
				block.apply_central_impulse(global_impact)
			area_3d.queue_free()
			

func _delete_blocks() -> void:
	for block in blocks:
		block.queue_free()
	blocks.clear()
