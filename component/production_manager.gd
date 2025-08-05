class_name ProductionManager
extends Node

signal current_production_update

@export var productionBoards: Array[PieceGrid]

var totalYields: ResourceProduction = ResourceProduction.new()

func gatherYields() -> void:
	for board in productionBoards:
		addYieldToTotal(board.getBoardYield())

func addYieldToTotal(resources: ResourceProduction):
	totalYields.addToResources(resources)
	current_production_update.emit(totalYields)
