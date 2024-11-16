extends HBoxContainer

# nodes
@export var _bus_name_label : Label
@export var _volume_slider : HSlider
@export var _volume_percentage_label : Label
@export var _child_audio_stream_player : AudioStreamPlayer

# variables
# TODO: This variables is temporary.
@export var start_volume_percentage := 50.0
@export var bus_index : int = -1 # not a valid bus index from the start
@export var bus_name : String
var volume_percentage : float

# timer to not reproduce the sounds every change on the slider
var _timer : Timer

func convert_percentage_to_db() -> float:
	# calculate db from the percentage
	var scale = 20.0
	var divisor = 50.0
	return scale * log(volume_percentage / divisor)

# NOTE: remember that if two sliders has the same bus index that may cause
# a bug. It's a good idea to code an script that handles all volumen sliders
# NOTE: by default the bus index is set to -1, an error will ocur. Remember
# to set the bus_index value to a existing one.

# Called when the node enters the scene tree for the first time.
func _ready():
	if bus_name:
		_bus_name_label.text = bus_name
	
	assert(bus_index >= 0, "Unvalid bus index!")
	
	# set default slider value.
	volume_percentage = start_volume_percentage
	_volume_slider.value = volume_percentage # set as max by default
	update_volume()

	for child in get_children():
		if child is AudioStreamPlayer:
			_child_audio_stream_player = child
			_timer = Timer.new()
			add_child(_timer)
			_timer.one_shot = true
			_timer.autostart = false
			_timer.wait_time = 1.0
			break
	

func update_volume():
	var volume_db = convert_percentage_to_db()
	if volume_percentage <= 0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
	AudioServer.set_bus_volume_db(bus_index, volume_db)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_volume_h_slider_value_changed(value : float):
	volume_percentage = value
	
	# update label text
	_volume_percentage_label.text = str(volume_percentage) + "%"
	
	update_volume()
	
	if _child_audio_stream_player and _timer.time_left <= 0:
		_child_audio_stream_player.play()
		_timer.start(1.0)
