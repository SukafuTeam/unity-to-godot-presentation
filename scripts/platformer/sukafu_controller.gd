class_name SukafuController
extends CharacterBody2D

const MOVE_SPEED = 400.0
const DASH_SPEED = 1000.0
const JUMP_VELOCITY = -700.0
const WALL_SLIDE_FALL_SPEED = 200.0

@onready var camera: Camera2D = $Camera
@onready var animation_container: Node2D = $AnimationContainer
@onready var animation: AnimatedSprite2D = $AnimationContainer/Animation

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Configurable variables
@export var coyote_time = 0.1
@export var dash_time = 0.2
@export var wall_stick_time = 0.2
@export var wall_jump_time = 0.18
@export var falling_gravity_scale = 2.0

# Camera Size variable
@export var ground_tilemap: TileMap

# Input handling improvements
var current_coyote_time = 0
var current_wall_jump_time = 0
var current_wall_stick_time = 0

# State controllers
var moving = false
var looking_right = true
var can_dash = false
var current_dash_time = 0
var can_double_jump = false
var double_jumping = false
var was_on_floor = false

func _ready():
	can_dash = true
	can_double_jump = true

	if ground_tilemap == null:
		return
	var size_right = ground_tilemap.get_used_rect().size.x - 2
	camera.limit_right = size_right * ground_tilemap.tile_set.tile_size.x

func _process(_delta):
	update_animation()

func _physics_process(delta):
	process_gravity(delta)
	process_jump(delta)
	process_dash(delta)
	process_movement()
	was_on_floor = is_on_floor()
	move_and_slide()

func process_gravity(delta):
	if is_on_floor():
		current_coyote_time = coyote_time
		can_dash = true
		if not was_on_floor:
			on_hit_ground()
		return
	
	current_coyote_time -= delta

	# If we are dashing, we don't want to apply gravity
	if current_dash_time > 0:
		return
	
	# The gravity changes depending on if we are falling or not
	# For better jump feel
	var gravity_force = gravity if velocity.y < 0 else gravity * falling_gravity_scale

	# Apply gravity
	velocity.y += gravity_force * delta

	# If the player is wall sliding, we want to limit the fall speed
	if current_wall_stick_time > 0:
		velocity.y = min(velocity.y, WALL_SLIDE_FALL_SPEED)

func process_jump(delta):
	# Timer to control for how long the player will be wall sliding
	# So the player can let go of direction button and still be able to jump out of the wall
	if current_wall_stick_time > 0:
		current_wall_stick_time -= delta

	# Timer to control for how long the user will be moving
	# out of a wall jump
	if current_wall_jump_time > 0:
		current_wall_jump_time -= delta
	
	if is_on_wall_only() and velocity.y > 0:
		# We are only sticking to the wall if we are moving towards it
		var dir = get_wall_normal()
		if dir.x < 0 and Input.is_action_pressed("right"):
			on_wall_stick()
		elif Input.is_action_pressed("left"):
			on_wall_stick()
	else:
		current_wall_stick_time = 0
	
	if not Input.is_action_just_pressed("jump"):
		return

	# Is wall sliding
	if current_wall_stick_time > 0:
		var dir = get_wall_normal()
		looking_right = dir.x > 0
		current_wall_jump_time = wall_jump_time
		on_jump()
		current_wall_stick_time = 0
		return
	
	# Is on ground or just left it
	if current_coyote_time > 0:
		on_jump()
		return
	
	# Is on air
	if can_double_jump:
		on_jump()
		can_double_jump = false
		double_jumping = true

func on_jump():
	# Squash and stretch animation when jumping
	var tween = create_tween()
	tween.tween_property(animation_container, "scale", Vector2(0.9, 1.1), 0.1)
	tween.tween_property(animation_container, "scale", Vector2.ONE, 0.1)
	# Apply jump velocity
	velocity.y = JUMP_VELOCITY
	# Reset coyote time
	current_coyote_time = 0

func process_dash(delta):
	# Timer to control for how long the player will be dashing
	if current_dash_time > 0:
		current_dash_time -= delta

	# If the player is already dashing, we can't to dash again
	if current_dash_time > 0:
		return

	# If the player doesn't press the dash button, or can't dash
	# just return
	if not Input.is_action_just_pressed("dash") or not can_dash:
		return

	# If the player is wall sliding, we want to dash in the opposite direction
	if current_wall_stick_time > 0:
		looking_right = !looking_right
	current_dash_time = dash_time
	# We can't dash again until we hit the ground or a wall
	can_dash = false
	# Reset the velocity so we don't keep the momentum from the jump or fall
	velocity.y = 0

func process_movement():
	# If the player just wall jumped, we want to move the player in the direction he is looking
	if current_wall_jump_time > 0:
		var speed = MOVE_SPEED if looking_right else -MOVE_SPEED
		velocity.x = speed
		return
	
	# If we are dashing, move the player in the direction he is looking
	if current_dash_time > 0:
		velocity.x = DASH_SPEED if looking_right else -DASH_SPEED
		return

	# Get the direction the player is inputting
	var direction = Input.get_axis("left", "right")
	moving = direction != 0
	# If the player is moving, we want to look in the direction he is moving
	# Otherwise, we want to keep looking in the direction we were looking
	if moving:
		looking_right = direction >= 0
	velocity.x = MOVE_SPEED * direction

func on_hit_ground():
	# Squash and stretch animation when hitting the ground
	var tween = create_tween()
	tween.tween_property(animation_container, "scale", Vector2(1.1, 0.9), 0.1)
	tween.tween_property(animation_container, "scale", Vector2.ONE, 0.1)
	# Resets the dash and double jump
	can_double_jump = true
	double_jumping = false
	can_dash = true

func on_wall_stick():
	current_wall_stick_time = wall_stick_time
	can_dash = true
	can_double_jump = true
	double_jumping = false

func update_animation():
	animation.flip_h = not looking_right

	if current_dash_time > 0:
		animation.play("dash")
		return

	if current_wall_stick_time > 0:
		animation.play("wall_sliding")
		return
	
	if double_jumping:
		animation.play("double_jump")
		return
	
	if not is_on_floor():
		if velocity.y < 0:
			animation.play("jump_up")
		else:
			animation.play("jump_down")
		return
	
	if moving:
		animation.play("run")
		return
	
	animation.play("idle")
