extends Node

@export_category("Rune Cube One")
@export var rune_cube_01 : RuneCube
@export var rc1_mesh : PackedScene
@export var rc1_location : Node3D
var rc1_spawned := false

func _process(delta: float) -> void:
	if rune_cube_01.activated == true and !rc1_spawned:
		var rc_instance = rc1_mesh.instantiate()
		get_parent().add_child(rc_instance)
		rc_instance.global_position = rc1_location.global_position
		rc_instance.global_rotation = rc1_location.global_rotation
		rc1_spawned = true
