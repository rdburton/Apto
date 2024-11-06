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
	
func _handle_zoom() -> void:
	if player.zoom_camera == true:
		size = lerp(size, 18.0, 0.05)
	if player.zoom_camera == false:
		size = lerp(size, 12.0, 0.05)

func update_position(delta : float) -> void:
	var rotated_offset = camera_pivot.global_transform.basis * camera_offset
	global_position = global_position.lerp(player.global_position + rotated_offset, move_speed)
	
