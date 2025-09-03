class_name GameClock
extends Node

@onready var gameClock: Timer = $GameTimer
@onready var ui: UserUi = $"../../UI"

signal game_tick

var timeSeconds = 0

func _ready() -> void:
	ui.advance_round.connect(self._on_advance_round)

func _on_advance_round():
	advance_time()

func advance_time():
	timeSeconds = timeSeconds + 1
	game_tick.emit(timeSeconds)


func get_game_time() -> int:
	return timeSeconds

func pause() -> void:
	gameClock.paused = true

func play() -> void:
	gameClock.paused = false

func toggle() -> bool:
	gameClock.paused = not gameClock.paused
	return gameClock.paused

func setGameSpeed(percentSpeed: float) -> void: 
	gameClock.wait_time = 1 * (1 / percentSpeed)
