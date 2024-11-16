extends TabContainer

signal item_selected(tab_index : int, item_index : int)

# Different from current tab index
var _tab_selected_index : int
var _item_selected_index : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_tiles_item_selected(index: int) -> void:
	_tab_selected_index = 0
	_item_selected_index = index
	
	item_selected.emit(_tab_selected_index, _item_selected_index)

func _on_collectables_item_selected(index: int) -> void:
	_tab_selected_index = 1
	_item_selected_index = index
	
	item_selected.emit(_tab_selected_index, _item_selected_index)
