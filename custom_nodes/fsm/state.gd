# this class represent an state in a finite state machine
class_name State
extends Node

# based on: 
# https://godot-essentials.gitbook.io/addons-documentation/components/finite-state-machine

#signal state_entered
signal state_finished()

# _has_finished is true if a state has been complete.
# when a state is finished signal state_finished
#var _has_finished : bool
# If this variable is set to true, the state will loop. If the state is set to 
# loop _has_finished will be always be false 
#var _should_loop : bool

# This function executes when the state enters for the first time as the current state.
func enter() -> void:
	pass

# This function executes when the state exits from being the current state.
func exit() -> void:
	pass

# This function is only use in a pushdown automata.
# This function executes when the state wake up after the current state is 
# popped.
# When a state is pop also called _enter() function
func wake_up() -> void:
	pass

# This function handle the input events
func handle_input(_event : InputEvent):
	pass

# This function executes on each frame of the finite state machine's physic process
func physics_update(_delta : float):
	pass

# This function executes on each frame of the finite state machine's process
func update(_delta : float):
	pass

# You can use this function generically to execute custom logic when an AnimationPlayer 
# finishes any animation. This receive the animation name as parameter to avoid errors 
# and be consistent with the original signal.
func _on_animation_player_finished(_anim_name: String):
	pass

# You can use this function generically to execute custom logic when an AnimatedSprite2D
# finishes any animation. This does not receive any params to avoid errors and be 
# consistent with the original signal.
func _on_animation_finished():
	pass
