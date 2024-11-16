# Cloud sprite
# Clouds are element of the background
class_name Cloud
extends Sprite2D

# an cloud can be visible or not.
# if it is not visible, there is not need to render the sprite 

var _velocity : int
var _direction : int # set to -1 or 1

var right_limit : int = 800 # hardcoded


func initialize(pos: Vector2, vel: int, dir : int, tex : Texture2D) -> void:
	visible = true
	position = pos
	_velocity = vel
	_direction = dir
	
	# select random texture
	texture = tex
	#centered = false
	#offset.y = CLOUD_1.get_height()

func set_as_visible(value: bool) -> void:
	visible = value

func _process(delta: float) -> void:
	# update position every frame
	position.x += _velocity * _direction * delta
	if position.x > right_limit: # This is not optimal
		visible = false
