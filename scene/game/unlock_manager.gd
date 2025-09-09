class_name UnlockManager
extends Node

signal unlocked

class Unlockable: 
	var isUnlocked: bool

	func _init(unlocked: bool) -> void:
		isUnlocked = unlocked


var unlockables: Dictionary[String, Unlockable] = {}
func _ready() -> void:
	unlockables["wheat"] = Unlockable.new(true)
	unlockables["water"] = Unlockable.new(false)
	unlockables["research"] = Unlockable.new(false)
	unlockables["gold"] = Unlockable.new(false)
	pass

func isUnlocked(key: String) -> bool:
	var item: Unlockable = unlockables[key]
	if not item: 
		return false

	return item.isUnlocked

func unlock(key: String) -> void:
	assert(unlockables.has(key))
	unlockables[key].isUnlocked = true
	unlocked.emit(key)
