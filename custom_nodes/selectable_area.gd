extends Area2D
class_name SelectableArea

signal item_selected(value: bool)

func _ready():
	pass

func _on_input_event(viewport: Viewport, event: InputEvent, shape_idx: int):
	# WARNING: Can be selected and place objects
	# TODO: We shold only be able to select an item in select mode.
	print("Not implemented yet!")

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: # move item
			item_selected.emit(event.is_pressed())
			#print("SelectedArea2D")
			#Signals.node_selected.emit(owner)
		if event.button_index == MOUSE_BUTTON_RIGHT: # erase
			#Signals.node_selected.emit(owner)
			pass
