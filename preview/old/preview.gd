extends Control

var snap_to_grid := true
var tile_size := 32
var _follow_mouse := false

@onready var texture_rect: TextureRect = $TextureRect

#@export var item_type

var is_dragged := false
var _offset := Vector2(0,0)

func _ready() -> void:
	add_to_group("preview")
	#_offset = get_rect().size/2
"""
func _physics_process(delta: float) -> void:
	if is_dragged:
		var pos = get_global_mouse_position()
		if snap_to_grid:
			global_position = Vector2(
				snapped(pos.x, tile_size), 
				snapped(pos.y, tile_size)
				) - _offset - Vector2(tile_size/2, tile_size/2)
		else:
			global_position = pos - _offset

func _unhandled_input(event: InputEvent) -> void:
	pass
"""

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
			if texture_rect.get_rect().has_point(get_local_mouse_position()):
				queue_free()
				
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				#print("texture_rect: ", texture_rect.get_rect())
				#print("local mouse position: ", get_local_mouse_position())
				if texture_rect.get_rect().has_point(get_local_mouse_position()):
					Signals.node_selected.emit(self)
"""
func _process(delta: float) -> void:
	# this is not the most efficient way by far
	if _follow_mouse:
		var mouse_pos = get_global_mouse_position()
		if snap_to_grid:
			global_position = Vector2(
				snapped(mouse_pos.x, tile_size), 
				snapped(mouse_pos.y, tile_size))
		else:
			global_position = mouse_pos

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				_follow_mouse = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_follow_mouse = true
		if event.button_index == MOUSE_BUTTON_RIGHT:
			queue_free()
"""
