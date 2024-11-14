class_name WallPlug extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var smoke_particles: GPUParticles3D = $SmokeParticles

@export var anim_finished := false
var reverse_finished := false
var current_position : Vector3

func _ready() -> void:
	current_position = global_transform.origin
		
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and !anim_finished:
		if body.is_dashing:
			_play_main()
			smoke_particles.emitting = true
		
func _play_main() -> void:
	if !anim_finished:
		_play_animation_from_position("main")
		
func _play_reverse() -> void:
	if !reverse_finished:
		_play_animation_from_position("reverse")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "main":
		anim_finished = true
		reverse_finished = false
		current_position += Vector3(0, 0, -4)

	if anim_name == "reverse":
		anim_finished = false
		reverse_finished = true
		current_position -= Vector3(0, 0, -4)
			
func _play_animation_from_position(anim_name: StringName) -> void:
		global_transform.origin = current_position
		animation_player.play(anim_name)
