extends Node3D

@export var block : Node3D
@export var destination : Node3D
@export var move_speed := 0.1
@onready var water: MeshInstance3D = $Water

var is_water = false
var dissolve_speed := 0.2
var dissolve_threshold := 1.0


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and body.is_water:
		print("transferring water")
		body.is_water = false
		is_water = true
		
func _process(delta: float) -> void:
	if is_water:
		dissolve_threshold = min(dissolve_threshold + dissolve_speed * -delta, 1.0)
		var water_material = water.get_active_material(0)
		water_material.set_shader_parameter("dissolve_threshold", dissolve_threshold)
		
		block.global_position = lerp(block.global_position, destination.global_position, delta * move_speed)
		
