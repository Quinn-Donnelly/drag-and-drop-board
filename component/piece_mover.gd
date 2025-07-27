class_name PieceMover
extends Node

@export var boards: Array[PieceGrid]

const POSITION_NOT_FOUND = -1

func _ready() -> void:
	for piece: Piece in get_tree().get_nodes_in_group("piece"):
		piece.drag_and_drop.drag_started.connect(_on_drag_started.bind(piece))
		piece.drag_and_drop.drag_canceled.connect(_on_drag_canceled.bind(piece))
		piece.drag_and_drop.drag_dropped.connect(_on_drag_dropped.bind(piece))

func _on_drag_started(_piece: Node):
	return

func _on_drag_canceled(_starting_position: Vector2, _piece: Piece):
	return 

func _on_drag_dropped(starting_position: Vector2, piece: Piece):
	var startingGameBoardIndex = _get_piece_board_index(starting_position)
	var endingGameBoardIndex = _get_piece_board_index(piece.get_global_mouse_position())
	var startingTilePosition = boards[startingGameBoardIndex].get_tile(starting_position)
	var endingTile: Vector2i = boards[endingGameBoardIndex].get_tile(piece.get_global_mouse_position())	
	var isEndingTileOccupied = boards[endingGameBoardIndex].is_occupied(endingTile)
	var hasStartingBoard = startingGameBoardIndex != POSITION_NOT_FOUND
	
	if hasStartingBoard:
		boards[startingGameBoardIndex].remove(startingTilePosition)
	
	if endingGameBoardIndex == POSITION_NOT_FOUND:
		piece.global_position = starting_position
		return
	
	if isEndingTileOccupied:
		var startingParent = piece.get_parent()
		var swapPiece: Node2D = boards[endingGameBoardIndex].get_piece(endingTile)
		swapPiece.global_position = starting_position
		boards[endingGameBoardIndex].remove(endingTile)
		swapPiece.reparent(startingParent) 
		if hasStartingBoard:
			boards[startingGameBoardIndex].add_piece(startingTilePosition, swapPiece)
	
	piece.reparent(boards[endingGameBoardIndex])
	boards[endingGameBoardIndex].add_piece(endingTile, piece)
	piece.global_position = boards[endingGameBoardIndex].get_global_tile_placement_position(endingTile)

func _get_piece_board_index(location: Vector2):
	for i in boards.size():
		if boards[i].is_on_grid(location): 
			return i 
	
	return POSITION_NOT_FOUND 
