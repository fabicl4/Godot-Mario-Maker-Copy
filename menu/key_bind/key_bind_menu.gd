extends Control

# NOTE: This class is hardcoded

var _currentKB : KeyBind

@onready var kb_move_right: KeyBind = $VBoxContainer/KB_MoveRight
@onready var kb_move_left: KeyBind = $VBoxContainer/KB_MoveLeft
@onready var kb_jump: KeyBind = $VBoxContainer/KB_Jump

# true when we are binding an action to a key
var _bind_state := false

func _ready() -> void:
	kb_move_right.bind_button_pressed.connect(
		_on_bind_button_pressed.bind(kb_move_right)
		)
	kb_move_left.bind_button_pressed.connect(
		_on_bind_button_pressed.bind(kb_move_left)
		)
	kb_jump.bind_button_pressed.connect(
		_on_bind_button_pressed.bind(kb_jump)
		)
		
	_update_labels()

func _input(event: InputEvent) -> void:
	if !_currentKB:
		return
		
	if event is InputEventKey || event is InputEventMouseButton:
		var all_ies : Dictionary = {}
		for ia in InputMap.get_actions():
			for iae in InputMap.action_get_events(ia):
				all_ies[iae.as_text()] = ia
		
		# check if the new key is already in the dict.
		# If yes, delete the old one.
		if all_ies.keys().has(event.as_text()):
			InputMap.action_erase_events(all_ies[event.as_text()])
		
		# This part is where the actual remapping occures:
		# Erase the event in the Input map
		InputMap.action_erase_events(_currentKB.action_name)
		# And assign the new event to it
		InputMap.action_add_event(_currentKB.action_name, event)
		
		# After a key is assigned, set current_button back to null
		_currentKB = null
		
		_update_labels() # refresh the labels
		

func _on_bind_button_pressed(kb : KeyBind):
	_currentKB = kb
	_currentKB.show_info()
	pass
	
func _update_labels() -> void:
	_update_label(kb_move_right, "move_right")
	_update_label(kb_move_left, "move_left")
	_update_label(kb_jump, "jump")
	
func _update_label(kb : KeyBind, action_name : String) -> void:
	# This is just a quick way to update the labels:
	var eb : Array[InputEvent] = InputMap.action_get_events(action_name)
	if !eb.is_empty():
		kb.set_keyname(eb[0].as_text())
	else:
		kb.set_keyname("error")
