# Finite State Machine
extends Node
class_name FSM

var _current_state : State = null

# trigger transition to next state
signal state_changed()

func set_state(new_state: State) -> void:
	if _current_state is State:
		_current_state._exit()
		
	_current_state = new_state
	
	if _current_state is State:
		_current_state._enter()
	
	state_changed.emit(_current_state)

func get_state() -> State:
	return _current_state

func _physics_process(delta: float) -> void:
	if _current_state is State:
		_current_state.physics_update(delta)
		
func _process(delta : float) -> void:
	if _current_state is State:
		_current_state.update(delta)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEvent and _current_state is State:
		# delegate handling the input to the 
		_current_state.handle_input(event)
