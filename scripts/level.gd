extends Node2D
class_name Level

@onready var _tilemap : TileMapLayer = $TileMapLayer

@onready var coins: Node = $Coins
@onready var palms: Node = $Palms
@onready var enemies: Node = $Enemies

# Player
const PLAYER = preload("res://player/player.tscn")
const PLAYER_PREVIEW = preload("res://preview/player_preview.tscn")

# prefabs
const GOLD_COIN = preload("res://items/coins/gold_coin.tscn")
const RED_DIAMOND = preload("res://items/coins/red_diamond.tscn")
const SILVER_COIN = preload("res://items/coins/silver_coin.tscn")

#################################################################################################### 
#preview
const GOLD_COIN_PREVIEW = preload("res://preview/coin/gold_coin_preview.tscn")
const RED_DIAMOND_PREVIEW = preload("res://preview/coin/red_diamond_preview.tscn")
const SILVER_COIN_PREVIEW = preload("res://preview/coin/silver_coin_preview.tscn")

const FG_PALM_1_PREVIEW = preload("res://preview/palm/fg_palm1_preview.tscn")
const FG_PALM_2_PREVIEW = preload("res://preview/palm/fg_palm2_preview.tscn")

# preview player
var player: Node2D


# TODO: Modify the level class so we can place any tile from different tilesets
# and different itemsets
#@export var tileset : TileSet
#@export var item_set : ItemSet

# Hardcoded
@export var is_preview : bool

func create():
	# create an empty level
	# load level from a file!
	pass
	
func _ready() -> void:
	_spawn_player(Vector2(17, 18))

# range is the affected area when we add an remove a tile
func add_tile(position : Vector2i, range : int) -> void:
	var cell_position := _get_cell_position(position)
	var surrounding_cells := _get_neighbor_cells(
		cell_position, range)
	
	_tilemap.set_cells_terrain_connect(surrounding_cells, 0, 0, true)
	# TODO: Remove this!
	#_tilemap.set_cell(cell_position, 1, Vector2i(4,4))
	
func remove_tile(position : Vector2i, range : int) -> void:
	var cell_position := _get_cell_position(position)
	var surrounding_cells := _get_neighbor_cells(
		cell_position, range)
	
	_tilemap.set_cells_terrain_connect( surrounding_cells, 0, -1, true)
	#_tilemap.set_cell(cell_position)
		
func _get_neighbor_cells(cell_position : Vector2i, range : int) -> Array[Vector2i]:
	var surrounding_cells : Array[Vector2i]
	
	var radius := range - 1
	
	var row := -radius
	var column : int
	while row <= radius:
		column = -radius
		while column <= radius:
			surrounding_cells.push_back( cell_position - Vector2i(column, row) )
			column+=1
		row+=1

	return surrounding_cells
"""	
func add_item(item_id: int, position: Vector2i, snap_to_grid : bool):
	var item := _get_item(item_id)
	if not item: # item does not exist
		return
	
	if snap_to_grid: # calculate new position
		pass
	
func _get_item(item_id: int) -> Item:
	pass
"""

func _get_cell_position(position : Vector2i) -> Vector2i:
	return _tilemap.local_to_map(position)
	
func tile_snapped_position(position : Vector2) -> Vector2:
	return to_global(_tilemap.map_to_local(_get_cell_position(position)))

func add_item(item_group: int, item : int, position : Vector2) -> void:
	# NOTE: Item group 0 it does not exits, 0 correspond to tiles that are not an item!
	if item_group == 1: # Coins
		# Check if not preview mode
		var node : Node
		if item == 0:
			if is_preview:
				node = GOLD_COIN_PREVIEW.instantiate()
			else:
				node = GOLD_COIN.instantiate()
		elif item == 1:
			if is_preview:
				node = SILVER_COIN_PREVIEW.instantiate()
			else:
				node = SILVER_COIN.instantiate()
		elif item == 2:
			if is_preview:
				node = RED_DIAMOND_PREVIEW.instantiate()
			else:
				node = RED_DIAMOND.instantiate()
		else:
			print("Unknow item")
			return;
		node.global_position = position
		coins.add_child(node)
		
	else:
		print("Not implemented other item groups!")

# Return true if the level can be saved!
# This function only will be executed in editor_mode!
func save_level(level_name: String) -> bool:
	# 1. Open/Create the file.
	var file = FileAccess.open(
			"res://levels/" + level_name + ".json", FileAccess.WRITE)
	if not file:
		print ("Could'nt save the level!")
		return false
	
	var save_dict = {}

	save_dict["player_position"] = {
		"x" : 0,
		"y" : 0,
	}

	# 2. Save tiles.
	# Reference: https://www.reddit.com/r/godot/comments/18guftn/how_to_save_and_load_tilemap_with_code/
	#var tile_map = _tilemap.get("tile_map_data")
	#save_dict["tilemap"] = JSON.stringify(tile_map) 
	var tilemap_layers := []
	tilemap_layers.resize(1) # NOTE: Only midground layer!
	tilemap_layers[0] = _tilemap.get_tile_map_data_as_array()
	
	save_dict["tilemap"] = tilemap_layers
	
	# 3. Save items.
	var nodes = get_tree().get_nodes_in_group("preview")
	
	var items := []
	for node in nodes:
		if node.has_method("save"):
			items.push_back( node.save() )
	
	for item in items:
		print( JSON.stringify(item) )
	
	save_dict["items"] = items
	
	# 4. Close the file.
	file.store_string(JSON.stringify(save_dict))
	file.close()
	
	return true

func load_level(level_name: String) -> void:
	# TODO: If we load a level on editor mode this line should be called!
	# clear()
	
	# A level can be loaded in the editor mode or in play mode
	# editor mode --load-> preview item
	# play mode   --load-> play item
	var file_data := FileAccess.get_file_as_string("res://levels/" + level_name)
	var json = JSON.new()
	var error = json.parse(file_data)
	if error != OK:
		return
	
	# NOTE: Only one layer in this moment.
	var tile_map_data = JSON.parse_string(json.data["tilemap"][0])
	_tilemap.set_tile_map_data_from_array(tile_map_data)
	
	# Items.
	var items = json.data["items"]
	if items:
		for i in items.size():
			var item_data = items[i]
			var item_index = item_data["index"] # item id
			var item_group = item_data["group"]
			var position = Vector2( item_data["position_x"], item_data["position_y"] )
			
			add_item(item_group, item_index, position)
		
	# Player.
	var player_position = json.data["player_position"]
	player.global_position = Vector2(player_position["x"], player_position["y"])
	#_spawn_player(Vector2(player_position["x"], player_position["y"]))
	
func _spawn_player(pos : Vector2) -> void:
	if is_preview:
		player = PLAYER_PREVIEW.instantiate()
		player.global_position = pos
		add_child(player)
	else:
		player = PLAYER.instantiate()
		player.global_position = pos
		add_child(player)
		var camera = Camera2D.new()
		player.add_child(camera)

# Delete all tiles and items of the level
func clear() -> void: # TODO
	# free all nodes.
	var nodes = get_tree().get_nodes_in_group("preview")
	for node in nodes: 
		node.queue_free()
		
	# delete all tiles in the tilemap
	_tilemap.clear()
