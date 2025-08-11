class_name PieceGrid
extends TileMapLayer

@export var size: Vector2i
@export var spriteOffset: Vector2

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
	return to_global(map_to_local(tile)) + spriteOffset

# Function removes from grid but does not manage the reparenting
func remove(location: Vector2i) -> void:
	grid[location].tree_exited.disconnect(_on_tree_exited)
	grid[location] = null

# first element is the positive yield the second is the cost
func getBoardYield() -> Array[ResourceProduction]:
	var yieldMods: Dictionary[Vector2i, Array]
	yieldMods[Vector2i(0,0)] = [ResourceProduction.new(), ResourceProduction.new()]
	for location in grid:
		var piece: Piece = grid[location] as Piece
		if piece and piece.isModifier():
			var pieceMod: Dictionary[Vector2i, Array] = piece.getModifierEffects()
			yieldMods = dictionaryAddMerge(yieldMods, pieceMod)

	var totalYields: ResourceProduction = ResourceProduction.new()
	var totalCost: ResourceProduction = ResourceProduction.new()
	for location in grid:
		var piece: Piece = grid[location] as Piece
		if piece:
			var bonusYieldMod: ResourceProduction = ResourceProduction.new()
			var multYieldMod: ResourceProduction = ResourceProduction.new()
			# TODO: clean this up
			multYieldMod.water = 1
			multYieldMod.wheat = 1 
			multYieldMod.gold = 1
			multYieldMod.research = 1
			
			if yieldMods.has(location):
				bonusYieldMod = yieldMods[location][0]
				multYieldMod = yieldMods[location][1]
			var toAdd = piece.getYield()
			toAdd.addToResources(bonusYieldMod)
			toAdd.multiplyResources(multYieldMod)
			totalYields.addToResources(toAdd)
			totalCost.addToResources(piece.getCost())
	return [totalYields, totalCost]

func dictionaryAddMerge(first: Dictionary[Vector2i, Array], second: Dictionary[Vector2i, Array]) -> Dictionary[Vector2i, Array]:
	var firstKeys = first.keys()
	var secondKeys = second.keys()
	var output: Dictionary[Vector2i, Array]
	for key in firstKeys:
		output[key] = [ResourceProduction.new(), ResourceProduction.new()]
	for key in secondKeys:
		if not output.has(key):
			output[key] = [ResourceProduction.new(), ResourceProduction.new()]
	
	for gridLocation in output:
		if first.has(gridLocation):
			output[gridLocation][0].addToResources(first[gridLocation][0])
			output[gridLocation][1].addToResources(first[gridLocation][1])
		if second.has(gridLocation):
			output[gridLocation][0].addToResources(second[gridLocation][0])
			output[gridLocation][1].addToResources(second[gridLocation][1])

	return output

func _on_tree_exited(location: Vector2i, _piece: Node) -> void:
	grid[location] = null
