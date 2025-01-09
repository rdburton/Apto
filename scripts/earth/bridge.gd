extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var anim_finished := false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and !anim_finished:
		animation_player.play("main")
		anim_finished = true
