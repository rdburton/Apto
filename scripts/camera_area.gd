extends Area3D

@onready var player_sc = get_node("res://scripts/player.gd")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.zoom_camera = true


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.zoom_camera = false
