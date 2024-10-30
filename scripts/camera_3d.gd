extends Camera3D

@export var player : CharacterBody3D
@export var move_speed := 0.2
var camera_offset := 8.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_handle_zoom()
	#look_at(player.global_position, Vector3.UP, false)
	
	
	#Handle camera X movement
	if player.velocity.x > 0:
		global_position.x = lerp(global_position.x, (player.global_position.x + camera_offset), move_speed)
	if player.velocity.x < 0:
		global_position.x = lerp(global_position.x, (player.global_position.x + camera_offset), move_speed)	

	#Handle camera Y movement
	#if player.is_bouncing == true:
	if player.velocity.y > 0:
		global_position.y = lerp(global_position.y, (player.global_position.y + camera_offset), move_speed)
	if player.velocity.y < 0:
		global_position.y = lerp(global_position.y, (player.global_position.y + camera_offset), move_speed)
	
	#Handle camera Z movement
	if player.velocity.z > 0:
		global_position.z = lerp(global_position.z, (player.global_position.z + camera_offset), move_speed)
	if player.velocity.z < 0:
		global_position.z = lerp(global_position.z, (player.global_position.z + camera_offset), move_speed)
		
	#Reset camera position
	else:
		global_position.x = lerp(global_position.x, (player.global_position.x + camera_offset), move_speed)
		global_position.y = lerp(global_position.y, (player.global_position.y + camera_offset), move_speed)
		global_position.z = lerp(global_position.z, (player.global_position.z + camera_offset), move_speed)
		
	
	

func _handle_zoom() -> void:
	if player.zoom_camera == true:
		size = lerp(size, 15.0, 0.1)
	if player.zoom_camera == false:
		size = lerp(size, 10.0, 0.1)
		
