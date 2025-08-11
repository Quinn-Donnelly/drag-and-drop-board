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


func subtractFromResources(resources: ResourceProduction) -> void:
	water -= resources.water
	wheat -= resources.wheat
	research -= resources.research
	gold -= resources.gold

func multiplyResources(resourceMultiplier: ResourceProduction) -> void:
	water *= resourceMultiplier.water
	wheat *= resourceMultiplier.wheat
	research *= resourceMultiplier.research
	gold *= resourceMultiplier.gold

func isLessThanEqualTo(resource: ResourceProduction) -> bool:
	return water <= resource.water && wheat <= resource.wheat && research <= resource.research && gold <= resource.gold

func _to_string() -> String:
	return "water: %d, wheat: %d, research: %d, gold: %d" % [water, wheat, research, gold]
