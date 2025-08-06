class_name Shop
extends PieceGrid

@export var available: Array[WorkerInfo]
@export var gameManager: GameManager
#TODO: refactor this to be a spawner or something
@export var pieceMover: PieceMover
@export var productionManager: ProductionManager

func _ready() -> void:
	gameManager.connect("start_game", self._on_game_start)
	productionManager.connect("current_production_update", self._on_resource_change)
	super._ready()

func setRandom() -> void: 
	for location in grid:
		createAndSet(location, available.pick_random())

func createAndSet(location: Vector2i, workerInfo: WorkerInfo) -> void:
	var item = workerInfo.scene.instantiate() as Piece
	item.workerInfo = workerInfo
	add_child(item)
	pieceMover.startListening(item)
	item.global_position = get_global_tile_placement_position(location)
	add_piece(location, item)

func add_piece(location: Vector2i, piece: Node) -> void:
	var unit = piece as Piece
	unit.drag_and_drop.connect("drag_started", self._on_drag_start.bind(unit))
	super.add_piece(location, piece)

func remove(location: Vector2i) -> void:
	var unit = (grid[location] as Piece)
	unit.drag_and_drop.disconnect("drag_started", self._on_drag_start.bind(unit))
	super.remove(location)

func reserveGoldCost(reserveAmount: int):
	var reserveResources = ResourceProduction.new()
	reserveResources.gold = reserveAmount
	productionManager.createResourceHold(reserveResources)

func _on_drag_start(unit: Piece):
	reserveGoldCost(unit.workerInfo.unitStats.cost)

func toggleAffordableUnits(currentGold: int) -> void:
	for unit: Piece in grid.values():
		if unit:
			unit.drag_and_drop.enabled = unit.workerInfo.unitStats.cost < currentGold

func _on_resource_change(currentResources: ResourceProduction):
	toggleAffordableUnits(currentResources.gold)

func _on_game_start() -> void:
	setRandom()
	
