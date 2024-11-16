@tool
extends Node2D
class_name BackgroundGrid

@export var tile_size := 32
@export var grid_intensity := 1.0
@export var color := Color.WHITE
@export var origin_point:= Vector2(0,0)
@export var zoom := Vector2(1, 1)

var ref_position : Vector2

const GRID_SHADER = preload("res://assets/shader/grid.gdshader")

var rect : Rect2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material = ShaderMaterial.new()
	material.shader = GRID_SHADER
	rect = get_viewport_rect()

func _draw() -> void:
	draw_rect(rect, color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_shader_parameters()
	
	grid_intensity = clampf(grid_intensity, 0, 1)

func _update_shader_parameters() -> void:
	var offset_position = ref_position - origin_point
	material.set_shader_parameter("u_offset", offset_position)
	material.set_shader_parameter("u_resolution", rect.size)
	material.set_shader_parameter("u_spacing", tile_size)
	material.set_shader_parameter("u_grid_intensity", grid_intensity)
	material.set_shader_parameter("u_zoom", floor(zoom) )
