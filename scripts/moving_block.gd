extends Node3D

@export var wait_time := 2.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var anim_completed := true
var anim_playing := false

func _process(delta: float) -> void:
	if anim_completed:
		animation_player.play("movement")
		anim_playing = true
		anim_completed = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "movement":
		anim_playing = false
		await get_tree().create_timer(wait_time).timeout
		anim_completed = true
