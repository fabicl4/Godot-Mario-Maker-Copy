extends Camera2D

var _drag_sen := 1.0

@onready var background_grid: BackgroundGrid = $"../Background/BackgroundGrid"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	background_grid.ref_position = position
	pass
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			position -= event.relative * _drag_sen / zoom
