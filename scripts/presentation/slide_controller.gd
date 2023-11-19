extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("next_slide"):
		Global.next_slide()
	
	if Input.is_action_just_pressed("previous_slide"):
		Global.previous_slide() 
