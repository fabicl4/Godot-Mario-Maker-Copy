extends Node

@onready var option_button: OptionButton = $VBoxContainer/ResoultionContainer/OptionButton

"""
TODO:
	Add borderless option
	Fix black borders fullscreen - 2560x1440 resolution
"""

var _index : int
var _array_sizes := [
	Vector2i(640,360),
	Vector2i(1280,720),
	Vector2i(1920,1080),
	Vector2i(2560,1440)
]

# at the start, populate the OptionButton
func _ready() -> void:
	option_button.add_item("640x360")
	option_button.add_item("1280x720")
	option_button.add_item("1920x1080")
	option_button.add_item("2560x1440")
	
	_index = 0;
	option_button.select(_index)

# new graphic option selected.
func _on_option_button_item_selected(index: int) -> void:
	_index = index
	_resize()

# after every change, execute this function
func _resize():
	if (_index >= _array_sizes.size() or _index < 0):
		_index = 0
		
	DisplayServer.window_set_size(
		_array_sizes[_index]
	)

func _on_check_box_toggled(toggled_on: bool) -> void:
	#TODO
	if toggled_on:
		# set fullscreen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		# disable fullscreen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	_resize()
