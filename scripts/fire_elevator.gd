extends Node3D

@export var fire_lever: Node3D
@export var point_a: Node3D
@export var point_b: Node3D
@export var curve : Curve

func _process(delta: float) -> void:
	var distance_a = point_a.global_position.y - global_position.y
	var distance_b = point_b.global_position.y - global_position.y
	var distance_between = point_b.global_position.y - point_a.global_position.y
	
	var t = 100.0 * (distance_between - global_position.y) / distance_between
	var weight = curve.sample(t)

	if fire_lever.is_ablaze:
		if t >= 0.1:
			await get_tree().create_timer(3).timeout
			global_position = lerp(global_position, point_b.global_position, weight)
		
		if t <= 1.0:
			await get_tree().create_timer(3).timeout
			global_position = lerp(global_position, point_a.global_position, weight)
