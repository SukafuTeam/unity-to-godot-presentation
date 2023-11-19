extends Node2D

@onready var button: PlatformerButton = $Button
@onready var door: Node2D = $Door

func _ready():
	button.button_pressed.connect(on_button_pressed)

func on_button_pressed():
	if door == null:
		return
	door.queue_free()
