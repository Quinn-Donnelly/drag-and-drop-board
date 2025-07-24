class_name DragAndDrop
extends Node

@export var target: Area2D
@export var enabled: bool

var dragging: bool = false
var offset: Vector2 = Vector2.ZERO
var startingPosition: Vector2 = Vector2.ZERO

func _ready() -> void:
	assert(target, "You must set a target for drag_and_drop")
	set_process(false)
	target.input_event.connect(_on_target_input_event.unbind(1))
	
func _on_target_input_event(_viewport: Node, _event: InputEvent) -> void:
	if not enabled:
		return
		
	if not dragging and not get_tree().get_first_node_in_group("dragging") and Input.is_action_just_pressed("select"):
		_start_dragging()
	elif dragging and Input.is_action_just_released("select"):
		_drop()
	elif dragging and Input.is_action_just_pressed("cancel"):
		_cancel_dragging()

func _physics_process(_delta: float) -> void:
	if dragging:
		target.global_position = target.get_global_mouse_position() + offset

func _start_dragging() -> void:
	set_process(true)
	startingPosition = target.global_position
	offset = target.global_position - target.get_global_mouse_position()
	dragging = true
	target.add_to_group("dragging")
	
func _stop_dragging() -> void:
	dragging = false
	target.remove_from_group("dragging")
	set_process(false)

func _cancel_dragging() -> void:
	target.position = startingPosition
	_stop_dragging()
	
func _drop() -> void:
	_stop_dragging()
