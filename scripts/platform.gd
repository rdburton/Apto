class_name Platform extends Node3D


var platform_velocity : Vector3
var initial_pos : Vector3

func _ready() -> void:
	initial_pos = global_position

func _process(delta: float) -> void:
	platform_velocity = global_position - initial_pos

func get_platform_velocity() -> Vector3:
	return platform_velocity
