class_name Shop
extends PieceGrid

@export var availableShopWorkers: Array[WorkerInfo]
@export var startingCapableUnits: Array[WorkerInfo]
@export var gameManager: GameManager
#TODO: refactor this to be a spawner or something
@export var pieceMover: PieceMover
@export var productionManager: ProductionManager
@export var shopRerollInterval: int


var resourceHoldNumber: int

func _ready() -> void:
	gameManager.connect("start_game", self._on_game_start)
	gameManager.gameClock.connect("game_tick", self._on_game_tick)
	productionManager.connect("current_production_update", self._on_resource_change)
	super._ready()

func setRandom(allowed: Array[WorkerInfo]) -> void: 
	for location in grid:
		createAndSet(location, allowed.pick_random(), true)

func createAndSet(location: Vector2i, workerInfo: WorkerInfo, removeOccupied: bool) -> void:
	if removeOccupied and is_occupied(location):
		var toBeRemoved: Piece = grid[location]
		remove(location)
		toBeRemoved.queue_free()

	var item = workerInfo.scene.instantiate() as Piece
	item.workerInfo = workerInfo
	add_child(item)
	pieceMover.startListening(item)
	item.global_position = get_global_tile_placement_position(location)
	add_piece(location, item)

func add_piece(location: Vector2i, piece: Node) -> void:
	var unit = piece as Piece
	unit.drag_and_drop.connect("drag_started", self._on_drag_start.bind(unit))
	unit.drag_and_drop.connect("drag_dropped", self._on_drag_drop.bind(unit))
	unit.drag_and_drop.connect("drag_canceled", self._on_drag_cancel)
	unit.drag_and_drop.enabled = canAfford(unit)
	super.add_piece(location, piece)

func remove(location: Vector2i) -> void:
	var unit = (grid[location] as Piece)
	unit.drag_and_drop.disconnect("drag_started", self._on_drag_start.bind(unit))
	unit.drag_and_drop.disconnect("drag_dropped", self._on_drag_drop.bind(unit))
	unit.drag_and_drop.disconnect("drag_canceled", self._on_drag_cancel)
	super.remove(location)

func reserveResourceCost(reserveAmount: ResourceProduction) -> void:
	resourceHoldNumber = productionManager.createResourceHold(reserveAmount)

func cancelReservation() -> void:
	productionManager.cancelHold(resourceHoldNumber)
	resourceHoldNumber = 0

func toggleAffordableUnits(_currentGold: int) -> void:
	for unit: Piece in grid.values():
		if unit:
			unit.drag_and_drop.enabled = canAfford(unit)

func canAfford(unit: Piece) -> bool:
	return unit.workerInfo.unitStats.cost.isLessThanEqualTo(productionManager.totalYields)

func _on_drag_start(unit: Piece):
	reserveResourceCost(unit.workerInfo.unitStats.cost)

func _on_drag_drop(_starting_position: Vector2, unit: Piece):
	if is_on_grid(unit.global_position):
		cancelReservation()
		return
	productionManager.processHold(resourceHoldNumber)

func _on_drag_cancel(_starting_location: Vector2) -> void:
	cancelReservation()

func _on_resource_change(currentResources: ResourceProduction):
	toggleAffordableUnits(currentResources.gold)

func _on_game_tick(time: int) -> void:
	if time % shopRerollInterval == 0:
		setRandom(availableShopWorkers)

func _on_game_start() -> void:
	setRandom(startingCapableUnits)
	
