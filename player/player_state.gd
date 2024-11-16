# Base state for all player states
extends State
class_name PlayerState

var _character : CharacterBody2D
var _animator : AnimatedSprite2D # animation player
var _health : Health

@export var start_state : NodePath

# parent state, could be null
var _parent : State

var _child_state : State

# setup all child states that this state may have
func _setup_instances():
	"""
	_fsm = FiniteStateMachine.new()
	
	for child in get_children(): # get all state node children
		if child is State:
			child.setup(_character, _animator, _health)
			child.state_finished.connect(_on_state_finished)
			child._parent = self
		else:
			push_warning("State machine contains child which is not 'State'")
	"""
	pass

# Inject state dependencies.
func setup(
	character : CharacterBody2D, 
	animator : AnimatedSprite2D,
	health : Health
):
	_character  = character
	_animator   = animator
	_health   = health
	# _controller
	_animator.animation_finished.connect(_on_animation_finished)
	
	# set up all child states if it has any
	_setup_instances()
