class_name PlatformerButton
extends Area2D

# This is the signal that will be emitted when the button is pressed
signal button_pressed

# This is the sprite that will be used for the button
@onready var sprite: Sprite2D = $Sprite

# These are the textures that will be used for whe the button is idle and pressed
@export var idle_text: Texture
@export var pressed_text: Texture

# This is used to prevent the button from emitting the signal multiple times
# Between presses
var was_pressed = false

func _process(_delta):
	var pressed = has_overlapping_bodies()
	sprite.texture = pressed_text if pressed else idle_text

	if pressed and not was_pressed:
		button_pressed.emit()

	was_pressed = pressed
