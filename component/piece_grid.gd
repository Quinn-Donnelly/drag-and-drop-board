class_name PieceGrid
extends TileMapLayer

@export var size: Vector2i

var grid: Dictionary[Vector2i, Node]

func _ready() -> void:
	for x in size.x:
		for y in size.y:
			grid[Vector2i(x, y)] = null

func is_on_grid(location: Vector2) -> bool:
	print(get_cell_source_id(get_local_mouse_position()))
	return get_cell_source_id(location) != -1
	
func get_tile(location: Vector2) -> Vector2i:
		return local_to_map(to_local(location))
