@tool
class_name Piece
extends Area2D


@export var workerInfo: WorkerInfo
var production: ResourceProduction
@onready var drag_and_drop = $DragAndDrop

func _ready() -> void:
	self.production = workerInfo.unitStats.production

func getYield() -> ResourceProduction:
	return production
