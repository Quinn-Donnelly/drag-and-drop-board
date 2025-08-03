class_name ui
extends Node

@export var gameManager: GameManager
@onready var gameClockLabel: Label = $GameClockLabel

func _ready() -> void:
	gameManager.gameClock.connect("game_tick", self._on_clock_update)

func _on_clock_update(gameTime: int) -> void:
	gameClockLabel.text = "Game Time: %d" % gameTime
