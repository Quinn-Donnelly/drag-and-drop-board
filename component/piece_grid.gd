class_name PieceGrid
extends TileMapLayer

@export var size: Vector2i

var grid: Dictionary[Vector2i, Node]

func _ready() -> void:
	for x in size.x:
		for y in size.y:
			grid[Vector2i(x, y)] = null

func is_on_grid(location: Vector2) -> bool:
	return get_cell_source_id(get_tile(location)) != -1	

func get_piece(location: Vector2i) -> Node:
	return grid[location]

func get_tile(location: Vector2) -> Vector2i:
		return local_to_map(to_local(location))

func is_occupied(location: Vector2i) -> bool:
	return grid[location] != null

func add_piece(location: Vector2i, piece: Node) -> void:
	assert(grid[location] == null, "Grid position is occupied")
	grid[location] = piece
	piece.tree_exited.connect(_on_tree_exited.bind(location, piece))

func get_global_tile_placement_position(tile: Vector2i) -> Vector2:
	return to_global(map_to_local(tile))

# Function removes from grid but does not manage the reparenting
func remove(location: Vector2i) -> void:
	grid[location].tree_exited.disconnect(_on_tree_exited)
	grid[location] = null


func _on_tree_exited(location: Vector2i, _piece: Node) -> void:
	grid[location] = null
	print("who the fuck")
