@tool
class_name Piece
extends Area2D


@export var workerInfo: WorkerInfo
var production: ResourceProduction
@onready var drag_and_drop = $DragAndDrop
@onready var sprite = $Sprite2D

func _ready() -> void:
	self.production = workerInfo.unitStats.production
	if self.workerInfo.unitSprite:
		sprite.texture = self.workerInfo.unitSprite
	

func getYield() -> ResourceProduction:
	return production

func getCost() -> ResourceProduction:
	return workerInfo.unitStats.cost

func getModifierEffects() -> Dictionary[Vector2i, Array]:
	# TODO: become location aware and apply
	var modifierEffect: Dictionary[Vector2i, Array]
	modifierEffect[Vector2i(0,0)] = workerInfo.unitStats.modifier
	return modifierEffect

func isModifier() -> bool:
	return not workerInfo.unitStats.modifier.is_empty()
