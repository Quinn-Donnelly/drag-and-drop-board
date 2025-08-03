class_name ui
extends Node

@export var gameManager: GameManager
@onready var gameClockLabel: Label = $GameClockLabel
@onready var currentResourceLabel: Label = $CurrentResourceLabel

func _ready() -> void:
	gameManager.gameClock.connect("game_tick", self._on_clock_update)
	gameManager.productionManager.connect("current_production_update", self._on_current_production_update)

func _on_clock_update(gameTime: int) -> void:
	gameClockLabel.text = "Game Time: %d" % gameTime

func _on_current_production_update(resources: ResourceProduction) -> void:
	currentResourceLabel.text = "Water: %d | Wheat: %d | Research: %d" % [resources.water, resources.wheat, resources.research]
