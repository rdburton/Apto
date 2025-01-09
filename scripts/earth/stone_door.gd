extends Node3D

@export var push_block_rest : Array[Area3D]
@export var particle_effects : Array[GPUParticles3D]

var is_activated : bool = false
var has_played : bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ground_particles: GPUParticles3D = $GroundParticles

func _process(delta: float) -> void:
	for area in push_block_rest:
		if !area.is_within:
			is_activated = false
			break
			
		if area.is_within:
			is_activated = true
		
	if is_activated and !has_played:
		animation_player.play("activate")
		for effects in particle_effects:
			effects.emitting = true
		has_played = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "activate":
		for effects in particle_effects:
			effects.emitting = false
