extends Node3D

@export var wait_time := 0.0

var hit_player := false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	await get_tree().create_timer(wait_time).timeout
	animation_player.play("main")
	
func _process(delta: float) -> void:
	if hit_player:
		get_tree().reload_current_scene()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		hit_player = true
