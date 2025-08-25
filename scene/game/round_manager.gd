class_name RoundManager
extends Node

@export var initialRoundGoal: ResourceProduction
@onready var productionManager: ProductionManager = $"../ProductionManager"
var roundCount = 1
var currentRoundGoal: ResourceProduction

func _ready() -> void:
	currentRoundGoal = initialRoundGoal
	productionManager.round_goal_paid.connect(self._on_round_goal_paid)

func getRoundGoal() -> ResourceProduction:
	return currentRoundGoal

func _on_round_goal_paid() -> void:
	roundCount += 1
