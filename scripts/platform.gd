class_name Platform extends Node3D

var platform_velocity : Vector3
var previous_pos : Vector3

func _ready() -> void:
	previous_pos = global_position

func _process(delta: float) -> void:
	platform_velocity = (global_position - previous_pos) / delta
	previous_pos = global_position
	
func get_platform_velocity() -> Vector3:
	return platform_velocity
