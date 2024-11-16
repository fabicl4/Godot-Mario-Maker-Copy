extends Node2D


"""
	Item group:
		- 0, Player
		- 1, Coins
		- 2, Spike
		- 3, Fg palms
		- etc
"""
@export var item_group : int
@export var item_index : int

func save():
	var save_dict = {
		"group" : item_group,
		"index" : item_index,
		"position_x" : global_position.x,
		"position_y" : global_position.y,
	}
	return save_dict

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("preview")
	pass # Replace with function body.

var _follow_mouse := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _follow_mouse:
		position = get_global_mouse_position()
"""
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		if event.button_index == MOUSE_BUTTON_LEFT:
			_follow_mouse = false


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("Selected")
			_follow_mouse = true
			get_viewport().set_input_as_handled()
			
			
"""
func _on_button_button_up() -> void:
	#_follow_mouse = false
	pass

func _on_button_button_down() -> void:
	#_follow_mouse = true
	Signals.node_selected.emit(self)


func _on_area_2d_area_entered(area: Area2D) -> void:
	"""
	Each preview item have an area2d. This area is needed to keep count of
	When an area overlaps with another area, the game is notify by them and 
	keeps track of every two overlapping areas.
	If there is overlapping areas in a game, the editor will notify the user.
	
	A coin does not care if it is colliding with the terrain or a palm or an enemy.
	An enemy only cares if he is collinding with a solid object. This means other enemies, tiles and
	top part of a palm.
	"""
	pass # Replace with function body.
