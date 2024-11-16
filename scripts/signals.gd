extends Node

# Global signals script
# Usage:
#	Declare callable function -> 
#		func _on_global_signals(): ...
# 	Connect to a global signal -> 
#		Signals.global_signal.connect(_on_global_signals)
#	Emit global signal -> 
#		Signals.global_signal.emit()

# select a preview node
signal node_selected(node)
