class_name PieceMover
extends Node

@export var boards: Array[PieceGrid]

const POSITION_NOT_FOUND = -1

func _ready() -> void:
	for piece: Piece in get_tree().get_nodes_in_group("piece"):
		piece.drag_and_drop.drag_started.connect(_on_drag_started.bind(piece))
		piece.drag_and_drop.drag_canceled.connect(_on_drag_canceled.bind(piece))
		piece.drag_and_drop.drag_dropped.connect(_on_drag_dropped.bind(piece))

func _on_drag_started(piece: Node):
	print("is hooked %s", piece)

func _on_drag_canceled(starting_position: Vector2, piece: Piece):
	print("cancel drag: %s, %s" % [starting_position, piece])

func _on_drag_dropped(starting_position: Vector2, piece: Piece):
	print("drag dropped: %s, %s" % [starting_position, piece])
	
	# Figure how what game board it's on
	var _startingGameBoardIndex = _get_piece_board_index(starting_position)
	var endingGameBoardIndex = _get_piece_board_index(piece.get_global_mouse_position())
	
	if endingGameBoardIndex == POSITION_NOT_FOUND:
		return
	
	var tile: Vector2i = boards[endingGameBoardIndex].get_tile(piece.get_global_mouse_position())
	print("moving to: %s" % tile)

func _get_piece_board_index(location: Vector2):
	for i in boards.size():
		if boards[i].is_on_grid(location): 
			return i 
	
	return POSITION_NOT_FOUND 
