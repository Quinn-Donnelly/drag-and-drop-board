class_name Shop
extends PieceGrid

@export var available: Array[WorkerInfo]
@export var gameManager: GameManager
#TODO: refactor this to be a spawner or something
@export var pieceMover: PieceMover

func _ready() -> void:
	gameManager.connect("start_game", self._on_game_start)
	super._ready()

func setRandom() -> void: 
	for location in grid:
		createAndSet(location, available.pick_random())

func createAndSet(location: Vector2i, workerInfo: WorkerInfo) -> void:
	var item = workerInfo.scene.instantiate() as Piece
	add_child(item)
	pieceMover.startListening(item)
	item.global_position = get_global_tile_placement_position(location)
	add_piece(location, item)

func _on_game_start() -> void:
	setRandom()
	
