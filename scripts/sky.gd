@tool
class_name SkyNode
extends Node2D

const SKY_COLOR_HEX = 0xddc6a1ff
const WATER_COLOR_HEX = 0x92a9ceff
const HORIZON_COLOR_HEX = 0xf5f1deff
const HORIZON_TOP_COLOR_HEX = 0xd1aa9dff

var sky_color : Color
var water_color : Color
var horizon_color : Color
var horizon_top_color : Color

@export var horizon_pos : float

var rect : Rect2
var sea_rect : Rect2

func _ready() -> void:
	rect = get_viewport_rect()
	sea_rect = Rect2(0,horizon_pos,rect.size.x,rect.size.y - horizon_pos)
	
	sky_color = Color.hex(SKY_COLOR_HEX)
	water_color = Color.hex(WATER_COLOR_HEX)
	horizon_color = Color.hex(HORIZON_COLOR_HEX)
	horizon_top_color = Color.hex(HORIZON_TOP_COLOR_HEX)

func _draw() -> void:
	draw_rect(rect, sky_color)
	draw_rect(sea_rect, water_color)
	
	# draw horizon lines
	var horizon_rect1 := Rect2(0, horizon_pos - 10, rect.size.x, 10)
	var horizon_rect2 := Rect2(0, horizon_pos - 16, rect.size.x, 4)
	var horizon_rect3 := Rect2(0, horizon_pos - 20, rect.size.x, 2)
	
	draw_rect(horizon_rect1, horizon_top_color)
	draw_rect(horizon_rect2, horizon_top_color)
	draw_rect(horizon_rect3, horizon_top_color)
	
	draw_line(Vector2(0,horizon_pos), Vector2(rect.size.x, horizon_pos), horizon_color)
