class_name Player extends CharacterBody3D

@export var speed := 5.0
@export var JUMP_VELOCITY := 4.5
@export var dash_power := 20.0

@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fire_particles: GPUParticles3D = $FireParticles
@onready var water_particles: GPUParticles3D = $WaterParticles

var dash_counter := 0
var total_dashes := 2
var movement_weight := 1.0
var zoom_camera := false
var has_double_dashed := false
var is_bouncing := false
var is_ablaze := false
var is_water := false
var is_playing_loop := false
var is_completed := false
var current_speed 
var platform_velocity: Vector3 = Vector3.ZERO

func _process(delta: float) -> void:
	emit_particles()
	

func _physics_process(delta: float) -> void:
	check_raycast()
	handle_animations()
	var current_velocity = get_velocity()
	current_speed = speed
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	movement_weight = clamp (movement_weight, 0.0, 1.0)
	if direction:
		velocity.x = lerp(velocity.x, direction.x * current_speed, movement_weight)
		velocity.z = lerp(velocity.z, direction.z * current_speed, movement_weight)
		
	else:
		velocity.x = lerp(velocity.x, move_toward(velocity.x, 0, current_speed), movement_weight)
		velocity.z = lerp(velocity.z, move_toward(velocity.z, 0, current_speed), movement_weight)

	if is_on_floor():
		if velocity.y <= 0:
			is_bouncing = false
			dash_counter = 0
			
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		movement_weight = 0.2
		if Input.is_action_just_pressed("air_dash") and !has_double_dashed:
			if dash_counter < total_dashes:
				if velocity.length() > 0:
					var velocity_horizontal = Vector3(velocity.x, 0.0, velocity.z)
					var velocity_direction = velocity_horizontal.normalized()
					velocity += lerp(velocity_direction, direction * dash_power, 1.0)
					dash_counter += 1

	move_and_slide()

func handle_animations() -> void:
	var animation_length = 0.0
	var	anim_near_end := 0.1
	var current_animation_pos = 0.0
	
	if animation_player.is_playing():
		current_animation_pos = animation_player.current_animation_position
		animation_length = animation_player.current_animation_length
		
	if Input.is_action_pressed("move_forward"):
		animation_player.play("Forward")
		is_playing_loop = false
	elif Input.is_action_pressed("move_back"):
		animation_player.play("Back")
		is_playing_loop = false
	elif Input.is_action_pressed("move_left"):
		animation_player.play("Left")
		is_playing_loop = false
	elif Input.is_action_pressed("move_right"):
		animation_player.play("Right")
		is_playing_loop = false
	else:
		if not is_playing_loop:
			is_playing_loop = true
		elif is_playing_loop and current_animation_pos >= (animation_length - anim_near_end):
			animation_player.stop()
			is_playing_loop = false
		
func complete_level(next_level_file : String) -> void:
	get_tree().change_scene_to_file(next_level_file)

func emit_particles() -> void:
	if is_ablaze:
		fire_particles.emitting = true
	else:
		fire_particles.emitting = false
		
	if is_water:
		water_particles.emitting = true
	else:
		water_particles.emitting = false

func check_raycast() -> void:
	var collider = ray_cast_3d.get_collider()
	platform_velocity = Vector3.ZERO
	if collider != null:
		if collider.get_parent() is Platform:
			if collider.get_parent().has_method("get_platform_velocity"):
				platform_velocity = collider.get_parent().get_platform_velocity()
				velocity += platform_velocity * 0.25
			else:
				platform_velocity = Vector3.ZERO
		else:
			platform_velocity = Vector3.ZERO
