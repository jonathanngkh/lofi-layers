class_name DragDrop
extends Node

signal drag_started
signal drag_cancelled(starting_position: Vector2)
signal dropped(starting_position: Vector2)

@export var enabled := true
@export var target : Area2D

var starting_position : Vector2
var offset := Vector2.ZERO
var dragging := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(target, "No target set for DragDrop component.")
	target.input_event.connect(_on_target_input_event.unbind(1))


func _on_target_input_event(_viewport: Node, event: InputEvent) -> void:
	if not enabled:
		return
		
	var dragging_object := get_tree().get_first_node_in_group("dragging")
	
	if not dragging and dragging_object:
		return
		
	if dragging and event.is_action_pressed("cancel_drag"):
		_cancel_dragging()
	elif not dragging and event.is_action_pressed("select"):
		_start_dragging()
	elif dragging and event.is_action_released("select"):
		_drop()


func _input(event: InputEvent) -> void:
	# to make esc key work for cancel drag
	if dragging and target and event.is_action_pressed("cancel_drag"):
		_cancel_dragging()
	# to make sure dropping still works in case where mouse has moved off of unit's collision shape
	elif dragging and event.is_action_released("select"):
		_drop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if dragging and target:
		target.global_position = target.get_global_mouse_position() + offset


func _start_dragging() -> void:
	dragging = true
	starting_position = target.global_position
	target.add_to_group("dragging")
	target.z_index = 99
	offset = target.global_position - target.get_global_mouse_position()
	drag_started.emit()


func _drop() -> void:
	_end_dragging()
	dropped.emit(starting_position)


func _cancel_dragging() -> void:
	_end_dragging()
	target.global_position = starting_position # added by me
	drag_cancelled.emit(starting_position)


func _end_dragging() -> void:
	dragging = false
	target.remove_from_group("dragging")
	target.z_index = 0
