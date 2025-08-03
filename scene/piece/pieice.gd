class_name Piece
extends Area2D

@onready var drag_and_drop = $DragAndDrop

func getYield():
	return {
		"water": 1,
		"wheat": 0,
		"research": 0
	}
