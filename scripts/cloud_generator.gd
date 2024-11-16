# generates clouds in the background.
extends Node

# NOTE: An optimization for this class cloud be do all this in a shader.

# spawn points and direction of the clouds
# different cloud sprites
@export var min_point : int
@export var max_point : int

# it use the horizon_cursor as reference to the hightest point
var max_height : int

const CLOUD_1 = preload("res://assets/sprites/cloud_1.png")
const CLOUD_2 = preload("res://assets/sprites/cloud_2.png")
const CLOUD_3 = preload("res://assets/sprites/cloud_3.png")

const MAX_CLOUDS_IN_SCREEN := 20
var current_number_of_clouds := 0

var rng = RandomNumberGenerator.new()

var timer : Timer

const CLOUD_TIME: int = 3
const MIN_CLOUD_SPEED := 10
const MAX_CLOUD_SPEED := 60

var _cloud_pool : Array[Cloud]
# When a cloud is no longer in use it will be added to the free_list
# the free_list holds an index to the actual cloud
#var _cloud_free_list : Array[int]

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.start(CLOUD_TIME)
	
	_populate_cloud_pool()

func _generate_cloud() -> void:
	# TODO: delete this!
	var w_width = 640
	var w_height = 360
	
	var r = rng.randi() % 3
	var tex : Texture2D
	if r == 0: tex = CLOUD_1
	elif r == 1: tex = CLOUD_2
	else: tex = CLOUD_3
	
	var position_x = rng.randi_range(-w_width, -w_width/2)
	var position_y = rng.randi_range(0, max_point)
	var position = Vector2(position_x, position_y - tex.get_size().y)
	var velocity = rng.randi_range(MIN_CLOUD_SPEED, MAX_CLOUD_SPEED)
	
	_get_cloud().initialize(position, velocity, 1, tex)

func _populate_cloud_pool():
	_cloud_pool.resize(MAX_CLOUDS_IN_SCREEN)
	#_cloud_free_list.resize(MAX_CLOUDS_IN_SCREEN)
	for i in MAX_CLOUDS_IN_SCREEN:
		var cloud := Cloud.new()
		add_child(cloud)
		cloud.set_as_visible(false) # TODO: Set cloud as inactive
		
		_cloud_pool[i] = cloud
		#_cloud_free_list.append(i)
	
	for i in MAX_CLOUDS_IN_SCREEN/2:
		var w_width = 640
		var w_height = 360
		
		var r = rng.randi() % 3
		var tex : Texture2D
		if r == 0: tex = CLOUD_1
		elif r == 1: tex = CLOUD_2
		else: tex = CLOUD_3
		
		var position_x = rng.randi_range(-w_width, w_width)
		var position_y = rng.randi_range(0, max_point)
		var position = Vector2(position_x, position_y - tex.get_size().y)
		var velocity = rng.randi_range(MIN_CLOUD_SPEED, MAX_CLOUD_SPEED)
		
		var cloud := _get_cloud()
		if cloud:
			cloud.initialize(position, velocity, 1, tex)

func _on_timer_timeout():
	#if current_number_of_clouds < MAX_CLOUDS_IN_SCREEN:
	#print("Generate new cloud")
	_generate_cloud()
		
	timer.start(CLOUD_TIME)

# return a unused cloud from the pool 
#func _get_cloud() -> Cloud:
#	var cloud := Cloud.new()
#	add_child(cloud)
#	return cloud

func _get_cloud() -> Cloud:
	# find a cloud that is not in use.
	# there are better ways to do this, but this function will be called so
	# infrequently that it is not worth it.
	for i in MAX_CLOUDS_IN_SCREEN:
		if not _cloud_pool[i].visible:
			return _cloud_pool[i]
	
	# all clouds are in use!
	return null

func _process(delta: float) -> void:
	# update active clouds?
	pass
