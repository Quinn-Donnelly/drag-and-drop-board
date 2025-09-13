class_name RoundManager
extends Node

signal round_goal_update
signal rounds_complete

@export var roundGenerationStats: Array[RoundGenerationStats]
@onready var productionManager: ProductionManager = $"../ProductionManager"
@onready var gameManager: GameManager = $"../"
var roundIndex = 0
var levelGoals: Array[ResourceProduction] = []

func _ready() -> void:
	productionManager.round_goal_paid.connect(self._on_round_goal_paid)
	gameManager.start_game.connect(self._on_game_start)

func getRoundGoal() -> ResourceProduction:
	assert(roundIndex < levelGoals.size(), "attempt to get round goal when all goals are finished")
	return levelGoals[roundIndex]

func _weighted_partition(n: int, total: float, weights: Array, power: float) -> Array:
	var raw = []
	var sum_raw = 0.0

	for i in range(n):
		var val = pow(randf(), power) * weights[i]
		raw.append(val)
		sum_raw += val
    
	var result = []
	for val in raw:
		result.append(val / sum_raw * total)
	return result

func _generate_round_goals() -> void: 
	for stats in roundGenerationStats:
		var roundGoal = ResourceProduction.new()
		var generatedGoal: Array = _weighted_partition(4, stats.max_resource, stats.weights, stats.power)
		roundGoal.wheat = generatedGoal[0]
		roundGoal.gold = generatedGoal[1]
		roundGoal.water = generatedGoal[2]
		roundGoal.research = generatedGoal[3]
		levelGoals.push_back(roundGoal)
		round_goal_update.emit(roundIndex, levelGoals)

func _resources_enabled() -> Array[bool]:
	var resourceNames: Array[String] = ["wheat", "gold", "water", "research"]
	var resourceStatus: Array[bool] = []
	for resource in resourceNames:
		resourceStatus.push_back(gameManager.unlockManager.isUnlocked(resource))
	return resourceStatus

func _on_game_start() -> void:
	_generate_round_goals()
	
func _on_round_goal_paid() -> void:
	if roundIndex == levelGoals.size() - 1:
		rounds_complete.emit()
		roundIndex = 0
		levelGoals.clear()
	else:
		roundIndex += 1

	round_goal_update.emit(roundIndex, levelGoals)
