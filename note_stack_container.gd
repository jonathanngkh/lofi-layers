extends HBoxContainer

@onready var left_tail := preload("res://left_crotchet_tail.tscn")
@onready var right_tail := preload("res://right_crotchet_tail.tscn")
var note_stack_counters := {
	"NoteStack1": {
		"low_note_counter": 0,
		"high_note_counter": 0
	},
	"NoteStack2": {
		"low_note_counter": 0,
		"high_note_counter": 0
	},
	"NoteStack3": {
		"low_note_counter": 0,
		"high_note_counter": 0
	},
	"NoteStack4": {
		"low_note_counter": 0,
		"high_note_counter": 0
	},
	"NoteStack5": {
		"low_note_counter": 0,
		"high_note_counter": 0
	},
	"NoteStack6": {
		"low_note_counter": 0,
		"high_note_counter": 0
	},
	"NoteStack7": {
		"low_note_counter": 0,
		"high_note_counter": 0
	},
	"NoteStack8": {
		"low_note_counter": 0,
		"high_note_counter": 0
	},
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for note_stack in self.get_children():
		for notation in note_stack.get_children():
			if not notation.name == "QuarterRest":
				notation.note_placed.connect(_on_notation_note_placed)
				notation.note_removed.connect(_on_notation_note_removed)


func _on_notation_note_placed(note_placed) -> void:
	var low_note_count := 0
	var high_note_count := 0
	var note_stack = note_placed.get_parent()
	for notation in note_stack.get_children():
		if notation.modulate.a == 1.0 and not notation.name == "QuarterRest":
			# remove all tails
			for child in notation.get_children():
				if child.is_in_group("crotchet_tail"):
					child.queue_free()
			# if low_note
			if notation.get_index() <= 8:
				low_note_count += 1
			# if high_note
			else:
				high_note_count += 1
	for notation in note_stack.get_children():
		if notation.modulate.a == 1.0 and not notation.name == "QuarterRest":
			if low_note_count <= high_note_count:
				var left_tail_spawn = left_tail.instantiate()
				notation.add_child(left_tail_spawn)
			else:
				var right_tail_spawn = right_tail.instantiate()
				notation.add_child(right_tail_spawn)


func _on_notation_note_removed(note_removed) -> void:
	for child in note_removed.get_children():
		if child.is_in_group("crotchet_tail"):
			child.queue_free()
	var low_note_count := 0
	var high_note_count := 0
	var note_stack = note_removed.get_parent()
	for notation in note_stack.get_children():
		if notation.modulate.a == 1.0 and not notation.name == "QuarterRest":
			# remove all tails
			for child in notation.get_children():
				if child.is_in_group("crotchet_tail"):
					child.queue_free()
			# if low_note
			if notation.get_index() <= 8:
				low_note_count += 1
			# if high_note
			else:
				high_note_count += 1
	for notation in note_stack.get_children():
		if notation.modulate.a == 1.0 and not notation.name == "QuarterRest":
			if low_note_count <= high_note_count:
				var left_tail_spawn = left_tail.instantiate()
				notation.add_child(left_tail_spawn)
			else:
				var right_tail_spawn = right_tail.instantiate()
				notation.add_child(right_tail_spawn)
