extends Node

@export var wall_plug01 : WallPlug
@export var wall_plug02 : WallPlug
@export var main_plug : WallPlug

var main_plug_in := false
var plug01_in := false
var plug02_in := false

func _process(delta: float) -> void:
	check_completion()
	printt(plug01_in, main_plug_in, plug02_in)
	
	if wall_plug01.anim_finished:
		if !main_plug_in and plug02_in and !plug01_in:
			wall_plug02._play_reverse()
			plug01_in = true
		else:
			plug01_in = true
			
	if wall_plug01.reverse_finished:
		plug01_in = false
		
	if wall_plug02.anim_finished:
		plug02_in = true
	if wall_plug02.reverse_finished:
		plug02_in = false

	if main_plug.anim_finished:
		if !plug01_in and plug02_in and !main_plug_in:
			wall_plug02._play_reverse()
			main_plug_in = true
		else:
			main_plug_in = true

func check_states() -> void:
	if wall_plug01.anim_finished:
		plug01_in = true
	if wall_plug01.reverse_finished:
		plug01_in = false
		
	if wall_plug02.anim_finished:
		plug02_in = true
	if wall_plug02.reverse_finished:
		plug02_in = false
		
	if main_plug.anim_finished:
		main_plug_in = true
	if main_plug.reverse_finished:
		main_plug_in = false
		
func check_completion() -> void:
	if main_plug_in and plug01_in and plug02_in:
		print("COMPLETED")
