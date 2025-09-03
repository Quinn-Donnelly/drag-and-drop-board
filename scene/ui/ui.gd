class_name UserUi
extends Node

signal attempt_pay_round
signal advance_round

@export var gameManager: GameManager
@onready var gameClockLabel: Label = $GameClockLabel
@onready var currentResourceLabel: Label = $CurrentResourceLabel
@onready var payRoundGoalButton: Button = $PayRoundGoalButton
@onready var comingRoundLabel: Label = $ComingRoundGoals
@onready var currentRoundLabel: Label = $CurrentRoundLabel
@onready var gameWinMessage: Label = $GameWinMessage
@onready var advanceRoundButton: Button = $AdvanceRoundButton

func _ready() -> void:
	gameManager.start_game.connect(self._on_start_game)
	gameManager.gameClock.connect("game_tick", self._on_clock_update)
	gameManager.productionManager.connect("current_production_update", self._on_current_production_update)
	gameManager.end_game.connect(self._on_game_end)
	payRoundGoalButton.pressed.connect(self._on_pay_round_button)
	gameManager.roundManager.connect("round_goal_update", self._on_round_goal_update)
	payRoundGoalButton.hide()
	comingRoundLabel.hide()
	currentRoundLabel.hide()
	gameWinMessage.hide()
	advanceRoundButton.disabled = true
	advanceRoundButton.hide()
	advanceRoundButton.pressed.connect(self._on_advance_round_button_pressed)

func _on_start_game() -> void:
	payRoundGoalButton.disabled = false
	payRoundGoalButton.show()
	comingRoundLabel.show()
	currentRoundLabel.show()
	gameWinMessage.hide()
	advanceRoundButton.disabled = false
	advanceRoundButton.show()

func _on_clock_update(gameTime: int) -> void:
	gameClockLabel.text = "Game Time: %d" % gameTime

func _on_current_production_update(resources: ResourceProduction) -> void:
	currentResourceLabel.text = "Water: %d | Wheat: %d | Research: %d | Gold: %d" % [resources.water, resources.wheat, resources.research, resources.gold]

func _on_pay_round_button() -> void:
	attempt_pay_round.emit()	

func _on_round_goal_update(index: int, listGoals: Array[ResourceProduction]) -> void:
	var message = ""
	var currentRoundMessage = ""
	for i in range(index, listGoals.size()):
		if i == index:
			currentRoundMessage += "Water: %d | Wheat: %d | Research: %d | Gold: %d\n" % [listGoals[i].water, listGoals[i].wheat, listGoals[i].research, listGoals[i].gold]
			continue
		message += "Water: %d | Wheat: %d | Research: %d | Gold: %d\n" % [listGoals[i].water, listGoals[i].wheat, listGoals[i].research, listGoals[i].gold]
	comingRoundLabel.text = message
	currentRoundLabel.text = currentRoundMessage

func _on_game_end() -> void:
	gameWinMessage.show()

func _on_advance_round_button_pressed() -> void:
	advance_round.emit()
