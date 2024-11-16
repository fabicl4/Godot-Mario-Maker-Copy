class_name Health
extends Node

# https://godot-essentials.gitbook.io/addons-documentation/components/health-component

# set max health in the editor
@export var _max_health : float;
var _current_health : float;
var _is_vulnerable : bool;

# Timer class use to count when the parent is vulnerable
var _vulnerable_timer: Timer;

enum TYPES {
	DAMAGE,
	HEALTH,
	REGEN
}

signal health_changed(amount: int, type: TYPES)
# signal to notify when a node is vulnerable
signal invulnerability_changed(active: bool)
# signal to notify when a node is dead
signal is_dead

func _ready():
	# create new timer
	_vulnerable_timer = Timer.new();
	_vulnerable_timer.set_one_shot(true) 
	_vulnerable_timer.timeout.connect(_on_timer_timeout)
	
	_current_health = _max_health
	
func _on_timer_timeout() -> void:
	print("Invulnerability time is out!")
	
	_is_vulnerable = false
	invulnerability_changed.emit(false)
	
func initiliaze(max_health: float) -> void:
	_max_health = max_health
	_current_health = max_health

func heal(value: float) -> void:
	_current_health += value
	if _current_health > _max_health:
		_current_health = _max_health
		health_changed.emit(value, TYPES.HEALTH)
	
func damage(value: float) -> void:
	if _current_health == 0:
		return
		
	_current_health -= value
	if _current_health <= 0:
		_current_health = 0
		
		is_dead.emit();
	else:
		health_changed.emit(value, TYPES.HEALTH)

func full_health() -> void:
	_current_health = _max_health
	
func enable_invulnerability(enable : bool, value : float) -> void:
	# setup and start timer
	# if the timer is playing, restart it.
	if enable: 
		_vulnerable_timer.start(value)
	else:
		# manually stop the timer.
		_vulnerable_timer.stop()
	
	# check change of state.
	if _is_vulnerable != enable: 
		invulnerability_changed.emit(enable)
		
	_is_vulnerable = enable

func check_is_dead() -> bool:
	return _current_health <= 0

func get_percentage() -> float:
	return _current_health * 100.0 / _max_health
