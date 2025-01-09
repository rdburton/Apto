extends Node3D

@export var activator : Node3D
@export var rune_cube : Node3D
@export var hand : Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var anim_finished : bool = false

func _process(delta: float) -> void:
	if activator.has_finished and !anim_finished:
		animation_player.play("tilt")
		anim_finished = true
		
	if rune_cube.deactivate:
		var animation_player = hand.get_child(0)
		animation_player.play("main")
		
