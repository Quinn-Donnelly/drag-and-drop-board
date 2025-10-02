class_name ProductionManager
extends Node

signal current_production_update
signal round_goal_paid

@export var userUi: UserUi
@export var productionBoards: Array[PieceGrid]
@onready var roundManager: RoundManager = $"../RoundManager"
var resourceHolds: Dictionary[int, ResourceProduction]

var totalYields: ResourceProduction = ResourceProduction.new()

func _ready() -> void:
	userUi.attempt_pay_round.connect(self._on_attempt_pay)

func gatherYields() -> void:
	for board in productionBoards:
		var resourceInfo = board.getBoardYield()
		addYieldToTotal(resourceInfo[0])
		processHold(createResourceHold(resourceInfo[1]))

func addYieldToTotal(resources: ResourceProduction):
	totalYields.addToResources(resources)
	current_production_update.emit(totalYields)

func createResourceHold(resources: ResourceProduction) -> int:
	var holdNumber = randi()	
	# TODO: Throw or return error if can't afford
	totalYields.subtractFromResources(resources)
	current_production_update.emit(totalYields)
	resourceHolds[holdNumber] = resources
	return holdNumber

func processHold(holdNumber: int) -> void:
	resourceHolds.erase(holdNumber)

func cancelHold(holdNumber: int) -> void:
	var refund: ResourceProduction = resourceHolds[holdNumber]
	if not refund:
		return
	totalYields.addToResources(refund)
	current_production_update.emit(totalYields)
	resourceHolds.erase(holdNumber)

func _on_attempt_pay() -> void:
	if roundManager.getRoundGoal().isLessThanEqualTo(totalYields):
		var id = createResourceHold(roundManager.getRoundGoal())
		processHold(id)
		round_goal_paid.emit()

