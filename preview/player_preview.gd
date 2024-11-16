extends Node2D

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
