extends Node2D

var _snap_to_grid := true
@export var _tile_size := 32

var _current_item : TextureRect

func _ready() -> void:
	Signals.node_selected.connect(_on_node_selected)

func _physics_process(delta: float) -> void:
	if _current_item:
		var mouse_pos = get_global_mouse_position()
		var offset = -_current_item.get_rect().size + Vector2(_tile_size/2, _tile_size/2)
		var pos = mouse_pos #- _current_item.get_rect().size
		if _snap_to_grid:
			_current_item.position = Vector2(
				snapped(pos.x, _tile_size),
				snapped(pos.y, _tile_size)
			) - offset
		else:
			_current_item.position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			_current_item = null

func _on_node_selected(node : TextureRect) -> void:
	_current_item = node
	pass
