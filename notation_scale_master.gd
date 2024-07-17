extends Control

var looping_mode := false
var practice_mode := false
var wait_mode := false
var loaded_notes
var current_node

@onready var note_stack_container: HBoxContainer = $NotationBoxRichTextLabel/Staff/NoteStackContainer
@onready var note_explosion := preload("res://assets/vfx/note_explosion_cpu_particles_2d.tscn")
@onready var perfect_label := preload("res://perfect_rich_text_label.tscn")
@onready var early_label := preload("res://early_rich_text_label.tscn")
@onready var late_label := preload("res://late_rich_text_label.tscn")
@onready var cleared_BPM_label := preload("res://cleared_bpm_rich_text_label.tscn")
@onready var BPM_tick_label := preload("res://bpm_tick_rich_text_label.tscn")


func _ready() -> void:
	Conductor.beat_incremented.connect(loop_music)
	Conductor.downbeat_incremented.connect(bouncing_ball_movement)
	$Button.pressed.connect(save_measures)
	$Button2.pressed.connect(play_saved_measures)
	$Button3.pressed.connect(start_practice_mode)
	$MinusButton.pressed.connect(change_bpm.bind("minus"))
	$PlusButton.pressed.connect(change_bpm.bind("plus"))
	$TempoRichTextLabel.text = "[center][b]Tempo: " + str(Conductor.bpm/2)
	for note_stack in note_stack_container.get_children():
		note_stack.mouse_entered.connect(_on_note_stack_mouse_interact.bind(note_stack, "entered"))
		note_stack.mouse_exited.connect(_on_note_stack_mouse_interact.bind(note_stack, "exited"))
		for notation in note_stack.get_children():
			if notation.name == "QuarterRest":
				notation.mouse_filter = MOUSE_FILTER_IGNORE
			else:
				notation.note_placed.connect(_on_note_head_note_placed)
				notation.note_removed.connect(_on_note_head_note_removed)


func check_note() -> void:
	# if current note == played note on the correct beat, get_punctuality and print it, if all correct, play riser and success sound
	
	pass


func change_bpm(plus_or_minus: String) -> void:
	var change_amount := 10
	if plus_or_minus == "plus":
		Conductor.bpm += change_amount
		$TempoRichTextLabel.text = "[center][b]Tempo: " + str(Conductor.bpm/2)
	elif plus_or_minus == "minus":
		Conductor.bpm -= change_amount
		$TempoRichTextLabel.text = "[center][b]Tempo: " + str(Conductor.bpm/2)
		
	if looping_mode or practice_mode or wait_mode:
		Conductor.change_bpm(Conductor.bpm)


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
	var accidental = ""
	for child in note_placed.get_children():
		if child.is_in_group("accidental"):
			if child.name == "Sharp":
				accidental = "#"
			if child.name == "DoubleSharp":
				accidental = "##"
			if child.name == "Flat":
				accidental = "b"
			if child.name == "DoubleFlat":
				accidental = "bb"
	$SamplerInstrument.play_note(note_placed.name.left(2)[0] + accidental, int(note_placed.name.left(2)[1]))
	$NoteExplosionCPUParticles2D.emitting = true
	$NoteExplosionCPUParticles2D.position = note_placed.global_position + Vector2(50,30)


func _on_note_head_note_removed(note_removed):
	pass


var composition = {}

func save_measures() -> void:
	# reset composition.json
	composition = {}
	# add each notation event to the json
	var event_number = 0
	for note_stack in note_stack_container.get_children():
		for notation in note_stack.get_children():
			if notation.modulate.a == 1.0: # rest/placed_note
				event_number += 1
				if not notation.name == "QuarterRest": # placed_note
					var accidental = ""
					for child in notation.get_children():
						if child.is_in_group("accidental"):
							if child.name == "Sharp":
								accidental = "#"
							if child.name == "DoubleSharp":
								accidental = "##"
							if child.name == "Flat":
								accidental = "b"
							if child.name == "DoubleFlat":
								accidental = "bb"
					composition["event" + str(event_number)] = {
						"note_value": notation.name.left(3)[-2] + accidental,
						"note_octave": int(notation.name.left(3)[-1]),
						"beat": int(notation.get_parent().name.left(10)[-1])
					}
				else: # rest
					composition["event" + str(event_number)] = {
						"note_value": "QuarterRest",
						"note_octave": -1,
						"beat": int(notation.get_parent().name.left(10)[-1])
					}
	# save data
	var file = FileAccess.open("res://composition.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(composition))


func play_saved_measures() -> void:
	#Conductor.start_conducting()
	Conductor.change_bpm(Conductor.bpm)
	# load loaded_notes
	var file = FileAccess.open("res://composition.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	loaded_notes = JSON.parse_string(content)
	#print(loaded_notes)
	looping_mode = true
	practice_mode = false


func load_notes() -> void:
	var file = FileAccess.open("res://composition.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	loaded_notes = JSON.parse_string(content)


func get_notes_to_play() -> void:
	for event in loaded_notes:
		if not event["note_value"] == "QuarterRest":
			pass


func start_practice_mode() -> void:
	looping_mode = false
	practice_mode = true
	# start conductor
	Conductor.change_bpm(Conductor.bpm)


func loop_music() -> void: # called when beat is incremented
	if looping_mode:
		for notation_event in loaded_notes:
			if not loaded_notes[notation_event]["note_value"] == "QuarterRest":
				if Conductor.measure % 2 == 0: # left measure
					if loaded_notes[notation_event]["beat"] == 1 and Conductor.beat_in_bar == 1:
						$SamplerInstrument.play_note(loaded_notes[notation_event]["note_value"], loaded_notes[notation_event]["note_octave"])
					if loaded_notes[notation_event]["beat"] == 2 and Conductor.beat_in_bar == 3:
						$SamplerInstrument.play_note(loaded_notes[notation_event]["note_value"], loaded_notes[notation_event]["note_octave"])
					if loaded_notes[notation_event]["beat"] == 3 and Conductor.beat_in_bar == 5:
						$SamplerInstrument.play_note(loaded_notes[notation_event]["note_value"], loaded_notes[notation_event]["note_octave"])
					if loaded_notes[notation_event]["beat"] == 4 and Conductor.beat_in_bar == 7:
						$SamplerInstrument.play_note(loaded_notes[notation_event]["note_value"], loaded_notes[notation_event]["note_octave"])
				else: # right measure
					if loaded_notes[notation_event]["beat"] == 5 and Conductor.beat_in_bar == 1:
						$SamplerInstrument.play_note(loaded_notes[notation_event]["note_value"], loaded_notes[notation_event]["note_octave"])
					if loaded_notes[notation_event]["beat"] == 6 and Conductor.beat_in_bar == 3:
						$SamplerInstrument.play_note(loaded_notes[notation_event]["note_value"], loaded_notes[notation_event]["note_octave"])
					if loaded_notes[notation_event]["beat"] == 7 and Conductor.beat_in_bar == 5:
						$SamplerInstrument.play_note(loaded_notes[notation_event]["note_value"], loaded_notes[notation_event]["note_octave"])
					if loaded_notes[notation_event]["beat"] == 8 and Conductor.beat_in_bar == 7:
						$SamplerInstrument.play_note(loaded_notes[notation_event]["note_value"], loaded_notes[notation_event]["note_octave"])



func bouncing_ball_movement() -> void: # called on downbeat incremented signal
	if looping_mode:
		# bounce from note to note
		if Conductor.measure % 2 == 0:
			if Conductor.beat_in_bar == 1:
				$BouncingRhythmContainerNode/BouncingRhythmIndicator.move_horizontally_to(515)
			if Conductor.beat_in_bar == 3:
				$BouncingRhythmContainerNode/BouncingRhythmIndicator.move_horizontally_to(760)
			if Conductor.beat_in_bar == 5:
				$BouncingRhythmContainerNode/BouncingRhythmIndicator.move_horizontally_to(1000)
			if Conductor.beat_in_bar == 7:
				$BouncingRhythmContainerNode/BouncingRhythmIndicator.move_horizontally_to(1240)
		else:
			if Conductor.beat_in_bar == 1:
				$BouncingRhythmContainerNode/BouncingRhythmIndicator.move_horizontally_to(1485)
			if Conductor.beat_in_bar == 3:
				$BouncingRhythmContainerNode/BouncingRhythmIndicator.move_horizontally_to(1725)
			if Conductor.beat_in_bar == 5:
				$BouncingRhythmContainerNode/BouncingRhythmIndicator.move_horizontally_to(1965)
			if Conductor.beat_in_bar == 7:
				$BouncingRhythmContainerNode/BouncingRhythmIndicator.move_horizontally_to(275)
	if practice_mode:
		# ball will bounce like in looping mode, but resets if note was not played, played early, or played late. checker will wait until past late first.
		pass
	if wait_mode:
		# bounce and stop on note until it's played. if it's a rest, bounce on it then move to next one
		pass
