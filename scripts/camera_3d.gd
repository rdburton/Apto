extends Camera3D

@onready var player : Player
@export var move_speed := 0.2
@export var camera_offset := Vector3(8, 8, 8)
@onready var camera_pivot: Node3D = %CameraPivot


func _ready() -> void:
	player = get_parent().get_parent()

func _process(delta: float) -> void:
	_handle_zoom()
	update_position(delta)
	#_handle_raycast()
	
func _handle_zoom() -> void:
	if player.zoom_camera == true:
		size = lerp(size, 18.0, 0.02)
	if player.zoom_camera == false:
		size = lerp(size, 12.0, 0.02)

func update_position(delta : float) -> void:
	var rotated_offset = camera_pivot.global_transform.basis * camera_offset
	global_position = global_position.lerp(player.global_position + rotated_offset, move_speed)
	
#func _handle_raycast() -> void:
		#camera_ray_cast.target_position = player.global_position - global_transform.origin
		#camera_ray_cast.force_raycast_update()
		#
		##print(camera_ray_cast.target_position)
		#if camera_ray_cast.is_colliding():
			#print("CAMERA COLLIDING")
			#var collider = camera_ray_cast.get_collider()
			#if collider != player:
				#print("COLLIDER:", collider.name)
				#handle_occlusion(collider)
			#else:
				#print("NO COLLISION DETECTED")
				#clear_occlusion()
				#
#func handle_occlusion(collider):
	#if collider is Node3D:
		##var material = collider.get_surface_override_material(0)
		#if collider.material:
			#print("Making Material Translucent for:", collider.name)
			#collider.material.set_shader_parameter("dissolve_amount", 0.5)
			#
#func clear_occlusion():
	#if camera_ray_cast.is_colliding():
		#var collider = camera_ray_cast.get_collider()
		#if collider is Node3D:
			#var material = collider.get_active_materials(0)
			#if material:
				#material.set_shader_parameter("dissolve_amount", 0.0)
