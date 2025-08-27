class_name GameManager
extends Node

signal start_game
signal end_game


@onready var gameClock: GameClock = $GameClock
@onready var productionManager: ProductionManager = $ProductionManager
@onready var gameStartDelay: Timer = $GameStartDelay
@onready var gameStartManager: StartGameSeedManager = $StartGameSeedManager
@onready var roundManager: RoundManager = $RoundManager

func _ready() -> void:
	gameClock.connect("game_tick", self._on_game_clock_tick)
	gameStartDelay.connect("timeout", self._start_game)
	roundManager.rounds_complete.connect(self._on_rounds_complete)

func _start_game() -> void:
	productionManager.addYieldToTotal(gameStartManager.getStartingSeedResources())
	start_game.emit()

func endGame() -> void: 
	gameClock.pause()
	end_game.emit()

func _on_game_clock_tick(_currentTime: int):
	productionManager.gatherYields()

func _on_rounds_complete() -> void:
	endGame()
