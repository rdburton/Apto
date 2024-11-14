extends Node3D
#
#@export var wall_plug1 : WallPlug
#@export var wall_plug2 : WallPlug
#
#func _process(delta: float) -> void:
	#if wall_plug1.anim_finished:
		#wall_plug2._play_reverse()
	#
	#if wall_plug2.anim_finished:
		#wall_plug1._play_reverse()
