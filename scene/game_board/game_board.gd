class_name GameBoard
extends TileMapLayer

@onready var piece_grid = $PieceGrid

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("select"):
		var _location: Vector2i = _getMousePosition()

func _getMousePosition() -> Vector2i:
	return local_to_map(to_local(get_global_mouse_position()))

func _is_on_board(location: Vector2i) -> bool:
	return get_cell_source_id(location) != -1
