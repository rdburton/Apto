extends Node3D

var player : Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

func _ready() -> void:
	animation_player.play("main")

	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.is_earth = true
		body.timer.start(12)

#
#func _on_area_3d_body_exited(body: Node3D) -> void:
	#if body.is_in_group("Player"):
		#timer.start()

#func _on_timer_timeout() -> void:
	#player.is_earth = false
