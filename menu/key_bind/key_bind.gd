extends HBoxContainer
class_name KeyBind

@export var label_name : String
@export var action_name : String

@onready var label: Label = $Label
@onready var button: Button = $Button

signal bind_button_pressed()

# call this function when you want to force returning to the unbinding state
func show_info():
	button.text = "press any key or mouse button"
	
func set_keyname(key_name : String):
	button.text = key_name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = label_name

func _on_button_pressed() -> void:
	bind_button_pressed.emit()
