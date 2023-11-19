extends Node

var current_slide = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_slide = 0

func previous_slide():
	# Check if a scene with the previous slide exists
	var scene_name = "res://slides/slide_" + str(current_slide - 1) + ".tscn"
	if ResourceLoader.exists(scene_name):
		current_slide -= 1	
	else:
		scene_name = "res://slides/title.tscn"
		current_slide = 0

	get_tree().change_scene_to_file(scene_name)

func next_slide():
	# Check if a scene with the next slide exists
	var scene_name = "res://slides/slide_" + str(current_slide + 1) + ".tscn"
	if ResourceLoader.exists(scene_name):
		current_slide += 1	
	else:
		scene_name = "res://slides/title.tscn"
		current_slide = 0

	get_tree().change_scene_to_file(scene_name)