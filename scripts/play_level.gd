extends Node2D

@onready var options_menu: CenterContainer = $UI/OptionsMenu
@onready var level: Level = $Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options_menu.hide()
	level.is_preview = false
	
	level.load_level("test.json")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_toggled(toggled_on: bool) -> void:
	options_menu.visible = toggled_on
