class_name PieceMover
extends Node

@export var boards: Array[PieceGrid]

const POSITION_NOT_FOUND: int = -1

func _ready() -> void:
	for piece: Piece in get_tree().get_nodes_in_group("piece"):
		startListening(piece)

func startListening(piece: Piece):
	piece.drag_and_drop.drag_started.connect(_on_drag_started.bind(piece))
	piece.drag_and_drop.drag_canceled.connect(_on_drag_canceled.bind(piece))
	piece.drag_and_drop.drag_dropped.connect(_on_drag_dropped.bind(piece))

func _on_drag_started(piece: Node):
	piece.z_index = 99	
	return

func _on_drag_canceled(_starting_position: Vector2, piece: Piece):
	piece.z_index = 0	
	return 

func _on_drag_dropped(starting_position: Vector2, piece: Piece):
	piece.z_index = 0
	var startingGameBoardIndex: int = _get_piece_board_index(starting_position)
	var endingGameBoardIndex: int = _get_piece_board_index(piece.get_global_mouse_position())
	
	if endingGameBoardIndex == POSITION_NOT_FOUND:
		piece.global_position = starting_position
		return
	
	var startingTileLocation: Vector2i = boards[startingGameBoardIndex].get_tile(starting_position)
	var endingTileLocation: Vector2i = boards[endingGameBoardIndex].get_tile(piece.get_global_mouse_position())	
	var isEndingTileOccupied: bool = boards[endingGameBoardIndex].is_occupied(endingTileLocation)
	var hasStartingBoard: bool = startingGameBoardIndex != POSITION_NOT_FOUND
	
	if startingGameBoardIndex == endingGameBoardIndex and startingTileLocation == endingTileLocation:
		piece.global_position = starting_position
		return

	if not boards[endingGameBoardIndex].is_location_enabled(endingTileLocation):
		piece.global_position = starting_position
		return

	if hasStartingBoard:
		boards[startingGameBoardIndex].remove(startingTileLocation)
	
	if isEndingTileOccupied:
		var startingParent: Node = piece.get_parent()
		var swapPiece: Node2D = boards[endingGameBoardIndex].get_piece(endingTileLocation)
		swapPiece.global_position = starting_position
		boards[endingGameBoardIndex].remove(endingTileLocation)
		swapPiece.reparent(startingParent) 
		if hasStartingBoard:
			boards[startingGameBoardIndex].add_piece(startingTileLocation, swapPiece)
	
	piece.reparent(boards[endingGameBoardIndex])
	boards[endingGameBoardIndex].add_piece(endingTileLocation, piece)
	piece.global_position = boards[endingGameBoardIndex].get_global_tile_placement_position(endingTileLocation)

func _get_piece_board_index(location: Vector2) -> int:
	for i in boards.size():
		if boards[i].is_on_grid(location): 
			return i 
	
	return POSITION_NOT_FOUND 
