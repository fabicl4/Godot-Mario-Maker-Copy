extends Node2D

@onready var control: Control = $UILayer/Control
@onready var options: CenterContainer = $UILayer/Options


func _ready() -> void:
	control.show()
	options.hide()

func _on_play_button_pressed() -> void:
	# transition to playground
	# TODO: We should transition to level selector menu
	get_tree().change_scene_to_file("res://scenes/playground.tscn")
	pass # Replace with function body.


func _on_edit_button_pressed() -> void:
	# transition to a level_editor scene
	get_tree().change_scene_to_file("res://scenes/level_editor.tscn")
	pass # Replace with function body.


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.


func _on_options_button_pressed() -> void:
	control.hide()
	options.show()
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit(0)


func _on_return_button_pressed() -> void:
	# Return to main menu from options
	control.show()
	options.hide()
	pass # Replace with function body.
