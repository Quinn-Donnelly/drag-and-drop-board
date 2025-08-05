class_name ResourceProduction
extends Resource

@export var water: int
@export var wheat: int
@export var research: int
@export var gold: int

func addToResources(resources: ResourceProduction) -> void:
	water += resources.water
	wheat += resources.wheat
	research += resources.research
	gold += resources.gold

func _to_string() -> String:
	return "water: %d, wheat: %d, research: %d, gold: %d" % [water, wheat, research, gold]
