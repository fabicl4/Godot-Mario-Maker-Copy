extends Node

@onready var player: CharacterBody2D = $Player

@onready var options_menu: CenterContainer = $UI/OptionsMenu
@onready var label: Label = $UI/Label

var _player_score : Node

# UI elements
@onready var hub: Control = $UI/HUB

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options_menu.hide()
	_player_score = get_node("/root/PlayerScore")
	
	_update_hub()
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_O:
			if options_menu.visible:
				options_menu.hide()
			else:
				options_menu.show()

func _process(delta: float) -> void:
	label.text = "velocity is: (%f,%f)" % [player.velocity.x, player.velocity.y]
	_update_hub()

func _update_hub() -> void:
	hub.score_label.text = str(_player_score.score)
	hub.health_bar.set_value_no_signal(player.health.get_percentage())
	hub.health_label.text = str(player.health._current_health) + "/" + str(player.health._max_health)
