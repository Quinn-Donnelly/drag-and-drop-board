class_name RoundManager
extends Node

signal round_goal_update
signal rounds_complete

@export var initialRoundGoal: ResourceProduction
@onready var productionManager: ProductionManager = $"../ProductionManager"
@onready var gameManager: GameManager = $"../"
var roundIndex = 0
var roundGoals: Array[ResourceProduction] = []

func _ready() -> void:
	productionManager.round_goal_paid.connect(self._on_round_goal_paid)
	gameManager.start_game.connect(self._on_game_start)

func getRoundGoal() -> ResourceProduction:
	assert(roundIndex < roundGoals.size(), "attempt to get round goal when all goals are finished")
	return roundGoals[roundIndex]

func _on_game_start() -> void:
	roundGoals.push_back(initialRoundGoal)
	var round2 = ResourceProduction.new()
	round2.wheat = 50
	roundGoals.push_back(round2)
	round_goal_update.emit(roundIndex, roundGoals)

func _on_round_goal_paid() -> void:
	if roundIndex == roundGoals.size() - 1:
		rounds_complete.emit()
		roundIndex = 0
		roundGoals.clear()
	else:
		roundIndex += 1

	round_goal_update.emit(roundIndex, roundGoals)
