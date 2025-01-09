class_name Platform extends Node3D

var platform_velocity : Vector3
var previous_pos : Vector3
var initial_y_pos : float
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	previous_pos = global_position
	initial_y_pos = global_position.y
	animation_player.play("main")
	
func _physics_process(delta: float) -> void:
	platform_velocity = (global_position - previous_pos)
	previous_pos = global_position
	global_position.y = initial_y_pos

func get_platform_velocity() -> Vector3:
	return platform_velocity
