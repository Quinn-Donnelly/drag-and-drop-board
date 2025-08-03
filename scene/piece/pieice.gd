class_name Piece
extends Area2D

@export var production: ResourceProduction
@onready var drag_and_drop = $DragAndDrop

func getYield() -> ResourceProduction:
	return production
