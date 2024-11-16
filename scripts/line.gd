@tool
extends Node2D
# Line in a 2d space
# not define by points

# width and height are offsets.

@export var line_width : float:
	set(value):
		line_width = value
		queue_redraw()
		
@export var length : float:
	set(value):
		length = value
		queue_redraw()
		
@export var height : float:
	set(value):
		height = value
		queue_redraw()
		
@export var color : Color:
	set(value):
		color = value
		queue_redraw()

func _ready():
	# TODO: delete this!
	length = 640 # init window width
	

func _draw():
	draw_line(
		Vector2(0,height),
		Vector2(length, height),
		color,
		line_width
		)
