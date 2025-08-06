class_name ProductionManager
extends Node

signal current_production_update

@export var productionBoards: Array[PieceGrid]
var resourceHolds: Dictionary[int, ResourceProduction]

var totalYields: ResourceProduction = ResourceProduction.new()

func gatherYields() -> void:
	for board in productionBoards:
		addYieldToTotal(board.getBoardYield())

func addYieldToTotal(resources: ResourceProduction):
	totalYields.addToResources(resources)
	current_production_update.emit(totalYields)

func createResourceHold(resources: ResourceProduction) -> int:
	var holdNumber = randi()	
	# TODO: Throw or return error if can't afford
	totalYields.subtractFromResources(resources)
	resourceHolds[holdNumber] = resources
	return holdNumber

func processHold(holdNumber: int) -> void:
	resourceHolds.erase(holdNumber)

func cancelHold(holdNumber: int) -> void:
	var refund: ResourceProduction = resourceHolds[holdNumber]
	if not refund:
		return
	totalYields.addToResources(refund)
	resourceHolds.erase(holdNumber)
