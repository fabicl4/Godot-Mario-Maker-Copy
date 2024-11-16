extends CharacterBody2D
# Player controller script

# NOTE: Code from:
# https://gmtk.itch.io/platformer-toolkit/devlog/395523/behind-the-code

# TODO: Add ground and air acceleration
# TODO: Coyote time
# TODO: Stagger state
# TODO: Dead state
# TODO: Jump buffer
# TODO: Air control

# BUG?: When moving the window the player lose all the speed!

# The world is divided into 32 pixels blocks
# 32 pixels is consider a unit
const UNIT_PIXEL_RELATION = 32

@export var animation : AnimatedSprite2D
@export var health : Health

@export var max_hp : int

# Max player jumping height (in 32 pixels units)
@export var jump_height : float
# time to reach max height
@export var time_to_apex : float
@export var max_horizontal_speed : int

@export var downward_movement_multiplier := 2.0

var _gravity_multiplier : float
var _jump_speed : float

var _gravity : Vector2

@onready var jump_audio: AudioStreamPlayer2D = $JumpAudio

func _ready() -> void:
	# NOTE: we use positive gravity
	_gravity = Vector2(0, 2 * (jump_height * UNIT_PIXEL_RELATION / (time_to_apex * time_to_apex)))
	_calculate_jump_speed()
	
	health.initiliaze(max_hp)
	
# This variable is true when the player want to realize a jump.
# The jump action will be buffered x amount of seconds.
var _wants_to_jump := false
# How many ms the jump action will be buffered.
var jump_buffer : float
var _jump_buffer_counter : float
var _pressing_jump := false

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("jump"):
			_wants_to_jump = true
			_pressing_jump = true
		if event.is_action_released("jump"):
			_pressing_jump = false
	
func _process(delta: float) -> void:
	# Update animation direction
	var direction := Input.get_axis("move_left", "move_right")
	if direction == 1:
		animation.flip_h = false
	elif direction == -1:
		animation.flip_h = true
	
	if _wants_to_jump:
		_jump_buffer_counter+= delta
		# if true the jump will no longer be buffered.
		if _jump_buffer_counter > jump_buffer:
			_jump_buffer_counter = 0 # reset counter
			_wants_to_jump = false

func _physics_process(delta: float) -> void:
	# Check if the player is in the air
	if not is_on_floor():
		_on_air_movement(delta)
	else:
		# The player is on the ground.
		_on_ground_movement(delta)
	"""
	if velocity.y > 0.01:
		_gravity_multiplier = downward_movement_multiplier
	else:
		_gravity_multiplier = 1
	"""
	_gravity_multiplier = 1.0
	move_and_slide()

func _on_ground_movement(delta : float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		jump_audio.play()
		_handle_jump()
		
	# Set animation
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		animation.play("run")
	else:
		animation.play("idle")

	_apply_movement(delta)

@export var jump_cut_off : float

func _on_air_movement(delta : float) -> void:
	# 1. update animation
	if velocity.y > 0.01: # Fall
		animation.play("fall")
	else: # On air
		animation.play("jump")
	
	# 2. handle horizontal movement
	_apply_movement(delta)
	
	# 3. handle vertical movement
	#-------------------------
	# TODO: Double jumping
	# apply gravity
	# variable jump height
	if (not _pressing_jump) and velocity.y < -0.01:
		# player release jump button and he is still jumping
		# the player should now gradually transition to falling state
		_gravity_multiplier = jump_cut_off
	
	elif velocity.y > 0.01: # Fall
		_gravity_multiplier = downward_movement_multiplier
	else: # On air
		_gravity_multiplier = 1.0
	
	# TODO: Cap max speed when falling
	velocity += _gravity * _gravity_multiplier * delta

"""
func _apply_movement() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		animation.play("run")
		velocity.x = direction * max_horizontal_speed
	else:
		animation.play("idle")
		velocity.x = move_toward(velocity.x, 0, max_horizontal_speed)
"""

func _handle_jump():
	velocity.y = -_jump_speed

# given a max
func _calculate_jump_speed():
	_jump_speed = 2 * UNIT_PIXEL_RELATION * jump_height / time_to_apex
	#print("jump speed = %d = 2 x %d / %f" % [_jump_speed, jump_height, time_to_apex])

@export var max_acceleration : float
@export var max_deceleration : float
@export var turn_speed : float
@export var max_air_acceleration : float
@export var max_air_deceleration : float

# units per second velocity
var _ups_velocity : float

func _apply_movement(delta : float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	var desired_velocity := Vector2(direction, 0) * max_horizontal_speed
	
	var acceleration : float
	var deceleration : float
	if is_on_floor():
		acceleration = max_acceleration
		deceleration = max_deceleration 
	else:
		acceleration = max_air_acceleration 
		deceleration = max_air_deceleration
	
	var max_speed_change : float
	if direction:
		if sign(direction) != sign(velocity.x):
			max_speed_change = turn_speed * delta
		else:
			max_speed_change = acceleration * delta
	else:
		max_speed_change = deceleration * delta
	
	# velocity in units
	_ups_velocity = move_toward(_ups_velocity, desired_velocity.x, max_speed_change)
	# real velocity units/s into pixels/s
	velocity.x = _ups_velocity * UNIT_PIXEL_RELATION
