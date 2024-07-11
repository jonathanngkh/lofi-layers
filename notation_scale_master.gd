extends Control

# same UI as flat.io
# all rests, mouse over a position to show a colored note. click to place it
# click and drag existing note to move it (only vertically)
# click time sign and get options to change it
# changes number of rests and distribution of notes on bars
# save button reads the composition and writes the notes and positions to an array and writes to a file
# need to name it
# page shows all the compositions by reading from the file
# import midi or musicxml or mxl or musescore mscz mscx
# study musicxml -- i think i'll use this. can convert to midi and back. and it's human readable-ish

@onready var note_stack_container: HBoxContainer = $NotationBoxRichTextLabel/Staff/NoteStackContainer



func _ready() -> void:
	$Button.pressed.connect(save_measures)
	for note_stack in note_stack_container.get_children():
		note_stack.mouse_entered.connect(_on_note_stack_mouse_interact.bind(note_stack, "entered"))
		note_stack.mouse_exited.connect(_on_note_stack_mouse_interact.bind(note_stack, "exited"))
		for notation in note_stack.get_children():
			if notation.name == "QuarterRest":
				notation.mouse_filter = MOUSE_FILTER_IGNORE
			else:
				notation.note_placed.connect(_on_note_head_note_placed)
				notation.note_removed.connect(_on_note_head_note_removed)
		#for note_head in note_stack.get_children():
			#note_head.mouse_entered.connect(_on_note_head_mouse_entered)


func _on_note_stack_mouse_interact(note_stack_entered: Control, action_type: String) -> void:
	for notation in note_stack_entered.get_children():
		if notation.name == "QuarterRest":
			if action_type == "entered":
				notation.modulate.a = 0.0
			elif action_type == "exited" and is_note_stack_active(note_stack_entered) == false:
				notation.modulate.a = 1.0


func is_note_stack_active(note_stack_to_check: Control) -> bool:
	for notation in note_stack_to_check.get_children():
		if not notation.name == "QuarterRest":
			if notation.modulate.a == 1.0:
				return true
	return false


func _on_note_head_note_placed(note_placed):
	$SamplerInstrument.play_note(note_placed.name.left(2)[0], int(note_placed.name.left(2)[1]))
	$NoteExplosionCPUParticles2D.emitting = true
	$NoteExplosionCPUParticles2D.position = note_placed.global_position + Vector2(50,30)


func _on_note_head_note_removed(note_removed):
	pass


func save_measures() -> void:
	var composition = []
	for note_stack in note_stack_container.get_children():
		for notation in note_stack.get_children():
			if notation.modulate.a == 1.0:
				composition.append(
					{
						"note_value": notation.name.left(3)[-2],
						"note_octave": int(notation.name.left(3)[-1]),
						"beat": int(notation.get_parent().name.left(10)[-1])
					}
				)
	print(composition)
