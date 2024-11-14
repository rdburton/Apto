extends Node3D

@export var drop_wait := 0.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rigid_body_3d: RigidBody3D = $RigidBody3D

var anim_finished := false
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		await get_tree().create_timer(drop_wait).timeout
		if !anim_finished:
			animation_player.play("wobble")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "wobble":
		anim_finished = true
		rigid_body_3d.freeze = false
