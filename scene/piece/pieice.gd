@tool
class_name Piece
extends Area2D


@export var workerInfo: WorkerInfo
@export var production: ResourceProduction
@onready var drag_and_drop = $DragAndDrop
@onready var sprite = $Sprite2D

func _ready() -> void:
	self.production = workerInfo.unitStats.production
	if self.workerInfo.unitSprite:
		sprite.texture = self.workerInfo.unitSprite
	

func getYield() -> ResourceProduction:
	return production
