extends Node3D

@onready var fire_particles: GPUParticles3D = $FireParticles
@onready var door: MeshInstance3D = $Door
@onready var static_body_3d: StaticBody3D = $Door/StaticBody3D

var dissolve_pct := 0.0
var dissolve_speed := 0.2
var is_ablaze = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and body.is_ablaze:
		is_ablaze = true
		fire_particles.emitting = true

func _process(delta: float) -> void:
	if is_ablaze:
		dissolve_pct = min(dissolve_pct + dissolve_speed * delta, 1.0)
		var door_material = door.get_active_material(0)
		door_material.set_shader_parameter("dissolve_pct", dissolve_pct)
	
	if dissolve_pct >= 0.5:
		static_body_3d.set_collision_layer_value(1, false)
	
	if dissolve_pct >= 1.0:
		is_ablaze = false
		queue_free()
