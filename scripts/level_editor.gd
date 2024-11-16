extends Node2D
class_name LevelEditor

# Handle tiles, item and character placement

enum MODE
{
	SELECT,
	ADD,
	ERASE,
}

var _mode := MODE.SELECT

@onready var cursor: Node2D = $cursor
@onready var level: Level = $Level
@onready var options_menu: CenterContainer = %OptionsMenu

var _brush_size : int = 1

var _snap_to_grid := true
@export var _tile_size := 32

var _current_item

var _item_group : int
var _item_index : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#level.load_level("test.json")
	options_menu.hide()
	
	level.is_preview = true
	
	Signals.node_selected.connect(_on_node_selected)
	pass # Replace with function body.

func _get_snapped_mouse_position() -> Vector2:
	return to_global(level.tile_snapped_position(get_local_mouse_position()))

	#var pos = get_local_mouse_position()
	#return Vector2(snapped(pos.x, _tile_size),snapped(pos.y, _tile_size)) + Vector2(_tile_size/2, _tile_size/2)

func _physics_process(delta: float) -> void:
	#if _snap_to_grid:
	cursor.position = _get_snapped_mouse_position()
	#cursor.position = get_local_mouse_position()
	
	if _current_item:
		"""
		var mouse_pos = get_local_mouse_position()
		var offset = -_current_item.get_rect().size + Vector2(_tile_size/2, _tile_size/2)
		var pos = mouse_pos #- _current_item.get_rect().size
		"""
		if _mode == MODE.ERASE:
			_current_item.queue_free()
			_current_item = null
			return
		if _snap_to_grid:
			"""
			_current_item.position = Vector2(
				snapped(pos.x, _tile_size),
				snapped(pos.y, _tile_size)
			) #- offset
			"""
			_current_item.position = _get_snapped_mouse_position()
		else:
			_current_item.position = get_local_mouse_position()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			_current_item = null

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_position := get_local_mouse_position()
		
		if _mode == MODE.ADD:
			if _item_group == 0: # Add tiles
				# Add tile or item
				# check last selected item
				if event.button_index == MOUSE_BUTTON_LEFT:
					level.add_tile(mouse_position, _brush_size)
				#elif event.button_index == MOUSE_BUTTON_RIGHT:
				#	level.remove_tile(mouse_position, _brush_size)
			elif _item_group == 1: # Add gold coin
				var position = _get_snapped_mouse_position()
				level.add_item(_item_group, _item_index, position)
		if _mode == MODE.ERASE:
			# Any other input event will be trap by the preview item
			level.remove_tile(mouse_position, _brush_size)

# TODO: add two items in the same place should not be posible!!!

func _on_save_button_pressed() -> void:
	#var num := RandomNumberGenerator.new().randi()
	#level.save_level("tmp_%d" % num)
	level.save_level("test")


# play button
func _on_button_pressed() -> void:
	# play the level.
	# TODO: Change this!
	level.save_level("test")
	get_tree().change_scene_to_file("res://scenes/play_level.tscn")
	pass # Replace with function body.


func _on_h_slider_value_changed(value: float) -> void:
	_brush_size = value
	#print("New brush value: ", value)


func _on_options_button_pressed() -> void:
	options_menu.visible = not options_menu.visible

func _on_node_selected(node) -> void:
	_current_item = node
	pass

func _on_editor_tools_new_selected_tool(tool_index: int) -> void:
	match tool_index:
		0: _mode = MODE.SELECT
		1: _mode = MODE.ADD
		2: _mode = MODE.ERASE
		3: print("Not implemented yet!")


func _on_editor_tools_snap_to_grid(value: bool) -> void:
	_snap_to_grid = value
	pass


func _on_tab_container_item_selected(tab_index: int, item_index: int) -> void:
	_item_group = tab_index
	_item_index = item_index
