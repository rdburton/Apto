class_name RuneCube extends Node3D

@export var rune_name : String
@export var text : String
var text_label
var panel
var activated := false
var deactivate := false
var fade_speed := 0.8

@onready var rune_cube: CSGBox3D = $RuneCube

func _process(delta: float) -> void:
	if activated and panel:
		var new_alpha = panel.modulate.a + fade_speed * delta
		panel.modulate.a = min(new_alpha, 1.0)
		if panel.modulate.a >= 1.0:
			activated = false
	
	if deactivate:
		var new_alpha = panel.modulate.a - fade_speed * delta
		panel.modulate.a = min(new_alpha, 1.0)
		if panel.modulate.a <= 0.0:
			deactivate = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		activated = true
		panel = body.get_node("TextDisplay/PanelContainer")
		text_label = body.get_node("TextDisplay/PanelContainer/RichTextLabel")
		if text_label:
			text_label.visible = true
			text_label.text = text
		rune_cube.queue_free()
		
		await get_tree().create_timer(4).timeout
		deactivate = true
