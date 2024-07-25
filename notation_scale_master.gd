extends Control

@export var using_aubio := false
@export var using_qwerty := true
@export var using_midi := true
@export var on_beat_window := 0.07
var looping_mode := false
var practice_mode := false
var wait_mode := false
var loaded_notes
var current_note_stack := 1
var notes_in_current_note_stack := []

@onready var note_stack_container: HBoxContainer = $NotationBoxRichTextLabel/Staff/NoteStackContainer
@onready var note_explosion := preload("res://assets/vfx/note_explosion_cpu_particles_2d.tscn")
@onready var perfect_label := preload("res://perfect_rich_text_label.tscn")
@onready var early_label := preload("res://early_rich_text_label.tscn")
@onready var late_label := preload("res://late_rich_text_label.tscn")
@onready var cleared_BPM_label := preload("res://cleared_bpm_rich_text_label.tscn")
@onready var BPM_tick_label := preload("res://bpm_tick_rich_text_label.tscn")
@onready var bouncing_rhythm_indicator: Sprite2D = %BouncingRhythmIndicator


func _ready() -> void:
	if using_aubio:
		PitchDetector.connect("detected_pitch", _on_pitch_detector_note_detected)
	if using_qwerty:
		QwertyListener.connect("qwerty_note_on", _on_qwerty_listener_note_on)
	if using_midi:
		MidiListener.connect("midi_note_on", _on_qwerty_listener_note_on)
	Conductor.beat_incremented.connect(loop_music)
	Conductor.downbeat_incremented.connect(_on_conductor_downbeat_incremented)
	$SaveButton.pressed.connect(save_measures)
	$PlayButton.pressed.connect(play_saved_measures)
	$PracticeButton.pressed.connect(start_practice_mode)
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
# C##5 5##C

func _on_note_head_note_placed(note_placed):
	var note_value = note_placed.name.left(note_placed.name.length() - 1)
	var note_octave = int(note_placed.name.right(1))
	$SamplerInstrument.play_note(note_value, note_octave)
	$NoteExplosionCPUParticles2D.emitting = true
	$NoteExplosionCPUParticles2D.position = note_placed.global_position + Vector2(50,30)


func _on_note_head_note_removed(_note_removed):
	pass


func save_measures() -> void:
	# reset composition.json
	var composition = {}
	# add each notation event to the json
	var event_number = 0
	for note_stack in note_stack_container.get_children():
		for notation in note_stack.get_children():
			if notation.modulate.a == 1.0: # rest/placed_note
				event_number += 1
				if not notation.name == "QuarterRest": # placed_note
					composition["event" + str(event_number)] = {
						"note_value": notation.name.left(notation.name.length() - 1),
						"note_octave": int(notation.name.right(1)),
						"beat": int(notation.get_parent().name.right(1))
					}
				else: # rest
					composition["event" + str(event_number)] = {
						"note_value": "QuarterRest",
						"note_octave": -1,
						"beat": int(notation.get_parent().name.right(1))
					}
	# save data
	var file = FileAccess.open("res://composition.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(composition))
	get_notes_in_current_note_stack()


func play_saved_measures() -> void:
	#Conductor.start_conducting()
	Conductor.change_bpm(Conductor.bpm)
	# load loaded_notes
	load_notes()
	#print(loaded_notes)
	looping_mode = true
	practice_mode = false


func load_notes() -> void:
	var file = FileAccess.open("res://composition.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	loaded_notes = JSON.parse_string(content)


func _on_pitch_detector_note_detected(note_detected) -> void:
	if practice_mode:
		# convert string pitch detected 44.4 to int 44
		var played_note = snapped(float(note_detected), 1)
		print("aubio snapped to: " + str(played_note))
		check_note()


func check_note() -> void:
	pass


func get_notes_in_current_note_stack() -> void:
	notes_in_current_note_stack = []
	for note_stack in note_stack_container.get_children():
		if note_stack.name.right(1) == str(current_note_stack):
			for notation in note_stack.get_children():
				if notation.modulate.a == 1.0:
					notes_in_current_note_stack.append(notation)


func _on_qwerty_listener_note_on(note_played) -> void: # called on player key press
	print(loaded_notes)
	#var played_note_string := MusicTheoryDB.get_note_name(note_played) + str(MusicTheoryDB.get_note_octave(note_played))
	#print("played_note_string: " + played_note_string)
	for event in loaded_notes:
		if not loaded_notes[event]["note_value"] == "QuarterRest":
			if loaded_notes[event]["beat"] == current_note_stack:
				var event_midi := MusicTheoryDB.get_note_value(loaded_notes[event]["note_value"], loaded_notes[event]["note_octave"])
				if note_played == event_midi:
					print("loaded note: " + loaded_notes[event]["note_value"] + str(loaded_notes[event]["note_octave"]) + " was played")
					for note_stack in note_stack_container.get_children():
						if note_stack.name.right(1) == str(current_note_stack): # same beat
							for notation in note_stack.get_children():
								if not notation.name == "QuarterRest":
									var notation_midi := MusicTheoryDB.get_note_value(notation.name.left(notation.name.length() - 1), int(notation.name.right(1)))
									if notation_midi == note_played:
										notes_in_current_note_stack.erase(notation)
										#if notes_in_current_note_stack.size() == 0:
											#cycle_note_stack_and_move_ball()
										# if early:
										notation.self_modulate = "08234e" # dark blue "outline"
										for child in notation.get_children():
											if child.name == "LeftCrotchetTail" or child.name == "RightCrotchetTail":
												child.self_modulate = "08234e"
										notation.get_node("InnerHead").visible = true
										#notation.get_node("InnerHead").self_modulate = "3caec6" # light blue base
										success_glow(notation)
										# if late: red
										# if perfect: glowing green
		var time_off_beat = Conductor.get_time_off_closest_beat_in_bar(Conductor.song_position_in_seconds)
		var punctuality := ""
		#if Conductor.get_closest_beat_in_bar(Conductor.song_position_in_seconds) % 2 != 0: # closest beat is down beat
			#if time_off_beat > on_beat_window:
				#punctuality = Conductor.get_punctuality(Conductor.song_position_in_seconds)
				#if punctuality == "early":
					#pass
				#elif punctuality == "late":
					#pass

var success_tweens_array = []
func success_glow(note_head) -> void:
	var max_glow := Color(0.5, 3.2, 0.5)
	var min_glow := Color(0.5, 1.5, 0.5)
	var tween_duration = Conductor.sec_per_beat
	var tween = create_tween()
	tween.set_loops()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(note_head, "self_modulate", min_glow, tween_duration).from(max_glow)
	tween.tween_property(note_head, "self_modulate", max_glow, tween_duration).from(min_glow)
	tween.play()
	success_tweens_array.append(tween)


func start_practice_mode() -> void:
	load_notes()
	# need to find a way to start the bouncing ball to start at stack 1 on beat 1
	#current_note_stack = 1
	#cycle_note_stack_and_move_ball()
	#bouncing_rhythm_indicator.move_horizontally_to(ball_positions[current_note_stack - 1])
	looping_mode = false
	practice_mode = true
	# start conductor
	Conductor.change_bpm(Conductor.bpm)


func _on_conductor_downbeat_incremented() -> void:
	bouncing_ball_movement()

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

var ball_positions := [275, 515, 760, 1000, 1240, 1485, 1725, 1965]

func reset_note_heads() -> void:
	for tween in success_tweens_array:
		tween.kill()
	for note_stack in note_stack_container.get_children():
		for notation in note_stack.get_children():
			notation.self_modulate = "000000"
			for child in notation.get_children():
				if child.name == "LeftCrotchetTail" or child.name == "RightCrotchetTail":
					child.self_modulate = "000000"
				notation.get_node("InnerHead").self_modulate = "000000"


func bouncing_ball_movement() -> void: # called on downbeat incremented signal
	if looping_mode:
		# bounce from note to note
		if Conductor.measure % 2 == 0:
			if Conductor.beat_in_bar == 1:
				bouncing_rhythm_indicator.move_horizontally_to(515)
			if Conductor.beat_in_bar == 3:
				bouncing_rhythm_indicator.move_horizontally_to(760)
			if Conductor.beat_in_bar == 5:
				bouncing_rhythm_indicator.move_horizontally_to(1000)
			if Conductor.beat_in_bar == 7:
				bouncing_rhythm_indicator.move_horizontally_to(1240)
		else:
			if Conductor.beat_in_bar == 1:
				bouncing_rhythm_indicator.move_horizontally_to(1485)
			if Conductor.beat_in_bar == 3:
				bouncing_rhythm_indicator.move_horizontally_to(1725)
			if Conductor.beat_in_bar == 5:
				bouncing_rhythm_indicator.move_horizontally_to(1965)
			if Conductor.beat_in_bar == 7:
				bouncing_rhythm_indicator.move_horizontally_to(275)
	if practice_mode:
		pass
		# ball will bounce like in looping mode, but resets if note was not played, played early, or played late. checker will wait until past late first.
		if notes_in_current_note_stack.size() == 1 and notes_in_current_note_stack[0].name == "QuarterRest":
			cycle_note_stack_and_move_ball()
		elif notes_in_current_note_stack.size() == 0:
			cycle_note_stack_and_move_ball()
	if wait_mode:
		# bounce and stop on note until it's played. if it's a rest, bounce on it then move to next one
		pass


func cycle_note_stack_and_move_ball() -> void:
	if current_note_stack < 8:
		current_note_stack += 1
		get_notes_in_current_note_stack()
		bouncing_rhythm_indicator.move_horizontally_to(ball_positions[current_note_stack - 1])
	else:
		reset_note_heads()
		current_note_stack = 1
		get_notes_in_current_note_stack()
		bouncing_rhythm_indicator.move_horizontally_to(ball_positions[current_note_stack - 1])
