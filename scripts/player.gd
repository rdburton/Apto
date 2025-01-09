class_name Player extends CharacterBody3D

@export var speed := 5.0
@export var JUMP_VELOCITY := 4.5
@export var dash_power := 20.0

@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fire_particles: GPUParticles3D = $FireParticles
@onready var water_particles: GPUParticles3D = $WaterParticles
@onready var earth_particles: GPUParticles3D = $EarthParticles
@onready var marker_light: SpotLight3D = $MarkerLight
@onready var camera_pivot: Node3D = %CameraPivot
@onready var timer: Timer = $Timer

var dash_counter := 0
var total_dashes := 1
var movement_weight := 1.0
var zoom_camera := false
var is_dashing := false
var has_double_dashed := false
var is_bouncing := false
var is_ablaze := false
var is_water := false
var is_earth := false
var is_playing_loop := false
var is_completed := false
var current_speed : float
var platform_velocity: Vector3 = Vector3.ZERO
var rotate_camera := false
var pushing_block : RigidBody3D = null
var timed_out = false


func _process(delta: float) -> void:
	emit_particles()
	death_check()
	check_raycast()
	handle_animations()
	print(timer.time_left)
	
	
func _physics_process(delta: float) -> void:
	var current_velocity = get_velocity()
	current_speed = speed
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var camera_pivot_basis := camera_pivot.global_transform.basis
	var direction := (camera_pivot_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	movement_weight = clamp (movement_weight, 0.0, 1.0)
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * current_speed, movement_weight)
		velocity.z = lerp(velocity.z, direction.z * current_speed, movement_weight)
		
	else:
		velocity.x = lerp(velocity.x, move_toward(velocity.x, 0, current_speed), movement_weight)
		velocity.z = lerp(velocity.z, move_toward(velocity.z, 0, current_speed), movement_weight)

	
	if is_on_floor():
		marker_light.visible = false
		if velocity.y <= 0:
			is_bouncing = false
			dash_counter = 0
		if is_dashing:
			is_dashing = false
			
	# Add the gravity.
	if not is_on_floor():
		marker_light.visible = true
		velocity += get_gravity() * delta
		movement_weight = 0.2
		if Input.is_action_just_pressed("air_dash") and !has_double_dashed:
			if dash_counter < total_dashes:
				if velocity.length() > 0:
					is_dashing = true
					var velocity_horizontal = Vector3(velocity.x, 0.0, velocity.z)
					var velocity_direction = velocity_horizontal.normalized()
					velocity += lerp(velocity_direction, direction * dash_power, 1.0)
					dash_counter += 1
					
	move_and_slide()
	
	#Check if the player is trying to push a PushBlock and allow them to push it
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody3D and "PushBlock" in collider.get_groups():
			pushing_block = collider as RigidBody3D
			pushing_block.apply_central_impulse(-collision.get_normal() * 5.0)

const FORWARD_ANGLE = 0.0
const LEFT_ANGLE = PI / 2
const RIGHT_ANGLE = -PI / 2
const BACK_ANGLE = PI
const ANGLE_TOLERANCE = 1.0

func wrap_angle(angle: float) -> float:
	# Wrap angle between -PI and PI
	return wrapf(angle, -PI, PI)

func get_directional_animation(camera_rotation_y: float) -> String:
	camera_rotation_y = wrap_angle(camera_rotation_y)

	if abs(camera_rotation_y - FORWARD_ANGLE) < ANGLE_TOLERANCE:
		return "Forward"
	elif abs(camera_rotation_y - LEFT_ANGLE) < ANGLE_TOLERANCE:
		return "Left"
	elif abs(camera_rotation_y - RIGHT_ANGLE) < ANGLE_TOLERANCE:
		return "Right"
	elif abs(camera_rotation_y - BACK_ANGLE) < ANGLE_TOLERANCE or abs(camera_rotation_y + BACK_ANGLE) < ANGLE_TOLERANCE:
		return "Back"
	return "Idle"  # Default if no match

func handle_animations() -> void:
	var camera_rotation_y = camera_pivot.rotation.y
	var animation = get_directional_animation(camera_rotation_y)

	if Input.is_action_pressed("move_forward"):
		if animation_player.current_animation != animation:
			animation_player.play(animation)

	elif Input.is_action_pressed("move_back"):
		var back_animation = get_directional_animation(camera_rotation_y + BACK_ANGLE)
		if animation_player.current_animation != back_animation:
			animation_player.play(back_animation)

	elif Input.is_action_pressed("move_left"):
		var left_animation = get_directional_animation(camera_rotation_y + LEFT_ANGLE)
		if animation_player.current_animation != left_animation:
			animation_player.play(left_animation)

	elif Input.is_action_pressed("move_right"):
		var right_animation = get_directional_animation(camera_rotation_y + RIGHT_ANGLE)
		if animation_player.current_animation != right_animation:
			animation_player.play(right_animation)

	else:
		if animation_player.is_playing():
			var animation_length = animation_player.current_animation_length
			var current_animation_pos = animation_player.current_animation_position
			var anim_near_end := 0.1  # How close to the end of an animation to consider it finished

			# Only switch to Idle if the current animation is nearly finished
			if current_animation_pos >= (animation_length - anim_near_end):
				if animation_player.current_animation != "Idle":
					animation_player.play("Idle")
		else:
			animation_player.play("Idle")

func emit_particles() -> void:
	if is_ablaze:
		fire_particles.emitting = true
	else:
		fire_particles.emitting = false
		
	if is_water:
		water_particles.emitting = true
	else:
		water_particles.emitting = false

	if is_earth:
		earth_particles.emitting = true
	else:
		earth_particles.emitting = false

	
	

func check_raycast() -> void:
	var collider = ray_cast_3d.get_collider()
	platform_velocity = Vector3.ZERO
	if collider != null:
		if collider.get_parent() is Platform:
			dash_counter = 0.0
			if collider.get_parent().has_method("get_platform_velocity"):
				platform_velocity = collider.get_parent().get_platform_velocity()
				velocity += platform_velocity.normalized() / 2
			#else:
				#platform_velocity = Vector3.ZERO
		else:
			platform_velocity = Vector3.ZERO

func complete_level(next_level_file : String) -> void:
	get_tree().change_scene_to_file(next_level_file)
	
func death_check()-> void:
	if global_position.y <= -20.0:
		get_tree().reload_current_scene()


func _on_timer_timeout() -> void:
	if is_earth:
		is_earth = false
		
	if is_water:
		is_water = false
		
	if is_ablaze:
		is_ablaze = false
