extends Node2D

@export var value := 1
@onready var _audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var _animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

# emit a signal to game manager
signal collected(value)

func _ready():
	
	collected.connect(PlayerScore.update_score)

	_animated_sprite.play("idle")

var _can_be_collected := false

func _process(_delta : float):
	if _can_be_collected:
		set_physics_process(false)
		_can_be_collected = false
		
		_animated_sprite.play("effect")
		_audio.play()
		
		collected.emit(value)

func _on_area_2d_body_entered(body : Node2D):
	# not longe detect collision
	if body is CharacterBody2D: # Player collision
		_can_be_collected = true
		#set_physics_process(false)
		#_animated_sprite.play("effect")
		#_audio.play()
		#collected.emit(value)
	
func _on_audio_stream_player_2d_finished():
	queue_free()

func _on_area_2d_body_exited(body : Node2D):
	if body is CharacterBody2D: # Player collision
		_can_be_collected = false
