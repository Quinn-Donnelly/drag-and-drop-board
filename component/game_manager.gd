class_name GameManager
extends Node

signal start_game
signal end_game


@onready var gameClock: GameClock = $GameClock
@onready var productionManager: ProductionManager = $ProductionManager
@onready var gameStartDelay: Timer = $GameStartDelay

func _ready() -> void:
	gameClock.connect("game_tick", self._on_game_clock_tick)
	gameStartDelay.connect("timeout", self._start_game)

func _start_game() -> void:
	start_game.emit()

func endGame() -> void: 
	end_game.emit()

func _on_game_clock_tick(_currentTime: int):
	productionManager.gatherYields()
