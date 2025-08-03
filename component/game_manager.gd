class_name GameManager
extends Node

signal start_game
signal end_game


@onready var gameClock: GameClock = $GameClock
@onready var productionManager: ProductionManager = $ProductionManager

func _ready() -> void:
	gameClock.connect("game_tick", self._on_game_clock_tick)

func startGame() -> void:
	start_game.emit()

func endGame() -> void: 
	end_game.emit()

func _on_game_clock_tick(_currentTime: int):
	productionManager.gatherYields()
