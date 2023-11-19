extends Node2D

# Buttons
@onready var button1: PlatformerButton = $Button1
@onready var button2: PlatformerButton = $Button2
@onready var button3: PlatformerButton = $Button3
@onready var button4: PlatformerButton = $Button4
@onready var button5: PlatformerButton = $Button5
@onready var button6: PlatformerButton = $Button6
@onready var button7: PlatformerButton = $Button7

# Sprites
@onready var sprite1: Sprite2D = $Sprite1
@onready var sprite2: Sprite2D = $Sprite2
@onready var sprite3: Sprite2D = $Sprite3

@onready var tween_title: Label = $TweenTitle

# Initial values
var initial_sprite1_pos: Vector2
var initial_sprite2_scale: Vector2
var initial_sprite2_pos: Vector2
var initial_sprite3_scale: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	button1.button_pressed.connect(on_button1_press)
	button2.button_pressed.connect(on_button2_press)
	button3.button_pressed.connect(on_button3_press)
	button4.button_pressed.connect(on_button4_press)
	button5.button_pressed.connect(on_button5_press)
	button6.button_pressed.connect(on_button6_press)
	button7.button_pressed.connect(on_button7_press)

	initial_sprite1_pos = sprite1.position
	initial_sprite2_scale = sprite2.scale
	initial_sprite2_pos = sprite2.position
	initial_sprite3_scale = sprite3.scale

func on_button1_press():
	var position1 = initial_sprite1_pos + Vector2(100, 0)
	var position2 = initial_sprite1_pos + Vector2(0, -100)
	var position3 = initial_sprite1_pos + Vector2(-100, 0)

	var tween = create_tween()
	tween.tween_property(sprite1, "position", position1, 0.2)
	tween.tween_property(sprite1, "position", position2, 0.2)
	tween.tween_property(sprite1, "position", position3, 0.2)
	tween.tween_property(sprite1, "position", initial_sprite1_pos, 0.2)

func on_button2_press():
	var tween = create_tween()
	tween.tween_property(sprite2, "scale", initial_sprite2_scale * 2, 0.5)
	tween.parallel().tween_property(sprite2, "rotation_degrees", 360, 0.5)

	tween.tween_property(sprite2, "scale", initial_sprite2_scale, 0.5)
	tween.parallel().tween_property(sprite2, "rotation_degrees", 0, 0.5)

func on_button3_press():
	var tween = create_tween()
	tween.tween_property(sprite2, "scale", initial_sprite2_scale * 2, 0.5)
	tween.parallel().tween_property(sprite2, "rotation_degrees", 360, 0.5)

	tween.tween_interval(1.0)

	tween.tween_property(sprite2, "scale", initial_sprite2_scale, 0.5)
	tween.parallel().tween_property(sprite2, "rotation_degrees", 0, 0.5)

func on_button4_press():
	var tween = create_tween()
	tween.tween_callback(func(): tween_title.text = "Estou esperando...")
	tween.tween_interval(1.0)
	tween.tween_callback(func(): tween_title.text = "Prontinho!")
	tween.tween_interval(1.0)
	tween.tween_callback(func(): tween_title.text = "Pressione o botão")

func on_button5_press():
	var tween = create_tween()
	tween.tween_property(
		sprite3,
		"scale",
		initial_sprite3_scale * 2, 0.5
	)
	tween.tween_property(
		sprite3,
		"scale",
		initial_sprite3_scale, 0.5
	)

func on_button6_press():
	var tween = create_tween()
	tween.tween_property(
		sprite3,
		"scale",
		initial_sprite3_scale * 2, 0.5
	).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(
		sprite3,
		"scale",
		initial_sprite3_scale,
		0.5
	).set_trans(Tween.TRANS_ELASTIC)

func on_button7_press():
	var tween = create_tween()
	tween.tween_property(
		sprite3,
		"scale",
		initial_sprite3_scale * 2, 0.5
	).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		sprite3, 
		"scale",
		initial_sprite3_scale,
		0.5
	).set_trans(Tween.TRANS_CUBIC)

