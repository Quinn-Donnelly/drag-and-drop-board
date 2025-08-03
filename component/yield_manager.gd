class_name ProductionManager
extends Node

@export var productionBoards: Array[PieceGrid]

var totalYields = {
	"water": 0,
	"wheat": 0,
	"research": 0
}

func gatherYields() -> void:
	for board in productionBoards:
		addYieldToTotal(board.getBoardYield())

func addYieldToTotal(resources):
	totalYields.water += resources.water
	totalYields.wheat += resources.wheat
	totalYields.research = resources.research
	print(totalYields)
	
