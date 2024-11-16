extends Control

signal snap_to_grid(value : bool)
signal new_selected_tool(tool_index : int)

@onready var snap_to_grid_button: CheckButton = $VBoxContainer/SnapToGridButton

func _ready() -> void:
	# set as pressed at the start
	snap_to_grid_button.button_pressed = true

func _on_snap_to_grid_button_toggled(toggled_on: bool) -> void:
	snap_to_grid.emit(toggled_on)


func _on_tools_item_selected(index: int) -> void:
	new_selected_tool.emit(index)
