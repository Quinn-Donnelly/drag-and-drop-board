class_name UserUi
extends Node

signal attempt_pay_round

@export var gameManager: GameManager
@onready var gameClockLabel: Label = $GameClockLabel
@onready var currentResourceLabel: Label = $CurrentResourceLabel
@onready var payRoundGoalButton: Button = $PayRoundGoalButton

func _ready() -> void:
	gameManager.gameClock.connect("game_tick", self._on_clock_update)
	gameManager.productionManager.connect("current_production_update", self._on_current_production_update)
	payRoundGoalButton.pressed.connect(self._on_pay_round_button)

func _on_clock_update(gameTime: int) -> void:
	gameClockLabel.text = "Game Time: %d" % gameTime

func _on_current_production_update(resources: ResourceProduction) -> void:
	currentResourceLabel.text = "Water: %d | Wheat: %d | Research: %d | Gold: %d" % [resources.water, resources.wheat, resources.research, resources.gold]

func _on_pay_round_button() -> void:
	attempt_pay_round.emit()	
