extends Node3D

@export var block : Node3D
@export var destination : Node3D
@export var move_speed := 3.0

@onready var water: MeshInstance3D = $Water
@onready var water_particles: GPUParticles3D = $WaterParticles

var is_water = false
var dissolve_speed := 0.2
var dissolve_threshold := 1.0
var destination_reached := false
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and body.is_water:
		body.is_water = false
		is_water = true
		water_particles.emitting = true

	
func _physics_process(delta: float) -> void:
	if is_water:
		dissolve_threshold = min(dissolve_threshold + dissolve_speed * -delta, 1.0)
		var water_material = water.get_active_material(0)
		water_material.set_shader_parameter("dissolve_threshold", dissolve_threshold)
		var distance = block.global_position.distance_to(destination.global_position)
		
		if distance > 0.001:  # When the block is far enough from the destination
		# Calculate speed, decreasing as distance shrinks, but not too drastically
			var dynamic_speed = move_speed * (distance / (distance + 1))
		# Move block toward the destination with dynamic speed
			var direction = (destination.global_position - block.global_position).normalized()
			block.global_position += direction * dynamic_speed * delta
		if destination_reached:
			print("destination reached")
		
