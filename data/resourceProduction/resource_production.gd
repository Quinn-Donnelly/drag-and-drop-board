class_name ResourceProduction
extends Resource

@export var water: int
@export var wheat: int
@export var research: int

func addToResources(resources: ResourceProduction) -> void:
	water += resources.water
	wheat += resources.wheat
	research += resources.research

func _to_string() -> String:
	return "water: %d, wheat: %d, research: %d" % [water, wheat, research]
