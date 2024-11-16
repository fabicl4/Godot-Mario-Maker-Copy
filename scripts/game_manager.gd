# Load at the start of the game
# Manage current game scene
class_name GameManager
extends Node

# We use a stack to keep track of the current loaded scene
# and be able to return to the previous one
# Example: MainMenu -> Options and Play -> Options
# we want to be able to return to the previous scene
var scene_stack = []
var curr_index : int

# key -> scene name, value -> scene path
# hardcoded into the script :)
var scene_dict = {
	"MainMenu": "",
	#...
}

signal change_scene(scene_name : String)
signal enter_scene(scene_name : String)
signal exit_scene(scene_name : String)

# Push a new scene into the scene stack and
func load_scene(scene_name : String) -> void:
	#TODO : get scene path from the scene_dict
	#TODO : load scene and push to the stack. Update scene index.
	pass

func _ready() -> void:
	# push the MainMenu scene to the stack
	load_scene("MainMenu")

"""
On start steps:
	1. Load configuration file and set configuration
	2. Set cursor
	3. Launch main menu.
"""
