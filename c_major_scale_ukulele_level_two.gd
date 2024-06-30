extends Control

@export var using_aubio: bool = false
@export var using_qwerty: bool = true
@export var using_midi: bool = false
@export var on_beat_window: float = 0.07
@export var only_correct_notes_allowed: bool = true

@onready var blank_style_box_flat = preload("res://assets/themes/blank_style_box_flat.tres")
@onready var ukulele_tab: Control = $TabBoxRichTextLabel/UkuleleTab
@onready var ukulele_tab_2: Control = $TabBoxRichTextLabel/UkuleleTab2
@onready var sampler_instrument: SamplerInstrument = $SamplerInstrument
@onready var sampler_timer: Timer = $SamplerTimer

var wave_effect := "[wave amp=100 freq=20]"
var rainbow_effect := "[rainbow freq=1.2]"
var shake_effect := "[shake]"
var pulse_effect := "[pulse]"
var fade_effect := "[fade]"
var tornado_effect := "[tornado]"
var late_color := Color(0.935, 0, 0.139)
var early_color := Color(0.234, 0.683, 0.776)
var default_color := Color(0.027, 0.137, 0.31)

@onready var note_labels_to_play: Array[Control]
@onready var note_label_to_play_index := 0
var notes_to_play_midi: Array[int]
@onready var current_note_label: Control
@onready var current_note: int
@onready var note_explosion := preload("res://assets/vfx/note_explosion_cpu_particles_2d.tscn")
@onready var perfect_label := preload("res://perfect_rich_text_label.tscn")
@onready var early_label := preload("res://early_rich_text_label.tscn")
@onready var late_label := preload("res://late_rich_text_label.tscn")
@onready var cleared_BPM_label := preload("res://cleared_bpm_rich_text_label.tscn")
@onready var BPM_tick_label := preload("res://bpm_tick_rich_text_label.tscn")
var is_checking_notes = true
var snapped_note # converted detected pitch note for checking
var note_explosions := []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TabBoxRichTextLabel/TitleRichTextLabel.text = $TabBoxRichTextLabel/TitleRichTextLabel.text.left(16) + str(Conductor.bpm/2)
	$ClearedBPMsControl/ClearedBPM.text = "[b]" + str(Conductor.bpm/2)
	$Button.pressed.connect(func(): pass)
	Conductor.beat_incremented.connect(func(): $Label.text = "Beat in bar 88: " + str(Conductor.beat_in_bar))
	Conductor.downbeat_incremented.connect(func(): $Label2.text = "Beat in bar 44: " + str(round(Conductor.beat_in_bar/2.0)))
	Conductor.upbeat_incremented.connect(bounce_current_note_label)
	if using_aubio:
		PitchDetector.connect("detected_pitch", _on_pitch_detector_note_detected)
	if using_qwerty:
		QwertyListener.connect("qwerty_note_on", _on_qwerty_listener_note_on)
	if using_midi:
		MidiListener.connect("midi_note_on", _on_qwerty_listener_note_on)
	remove_tab_outlines(ukulele_tab)
	remove_tab_outlines(ukulele_tab_2)
	get_note_labels_to_play((ukulele_tab))
	get_note_labels_to_play((ukulele_tab_2))
	current_note_label = note_labels_to_play[note_label_to_play_index]
	current_note = MusicTheoryDB.get_midi_pitch(current_note_label.get_parent().name.left(1) + "_String_" + current_note_label.text[-1])
	for note_label in note_labels_to_play:
		notes_to_play_midi.append(MusicTheoryDB.get_midi_pitch(note_label.get_parent().name.left(1) + "_String_" + note_label.text[-1]))
		# will present issues for double digit tab notes
		# spawn explosion and update note_explosion array
		var note_explosion_spawn = note_explosion.instantiate()
		add_child(note_explosion_spawn)
		note_explosions.append(note_explosion_spawn)
		# show only first note
		if not note_label == current_note_label:
			note_label.modulate.a = 0


func get_note_labels_to_play(from_ukulele_tab: Control) -> void:
	var new_note_labels := []
	for string in from_ukulele_tab.get_children():
		for control in string.get_children():
			if control.is_class("BoxContainer"): #notecontainer
				for note_label in control.get_children():
					if not note_label.text == "":
						new_note_labels.append(note_label)
						new_note_labels.sort_custom(func(a, b): return a.name.naturalnocasecmp_to(b.name) < 0)
	note_labels_to_play.append_array(new_note_labels)


func _on_pitch_detector_note_detected(note_detected) -> void:
	if is_checking_notes:
		# convert string pitch detected 44.4 to int 44
		snapped_note = snapped(float(note_detected), 1)
		print(snapped_note)
		check_note()


func _on_qwerty_listener_note_on(note_played) -> void:
	if is_checking_notes:
		snapped_note = note_played
		check_note()


func play_all_notes() -> void:
	for midi_note in notes_to_play_midi:
		sampler_instrument.play_note(str(MusicTheoryDB.get_note_name(midi_note)), MusicTheoryDB.get_note_octave(midi_note))
		for note_midi in notes_to_play_midi:
			# if note_label is visible:
			if note_labels_to_play[notes_to_play_midi.find(midi_note)].modulate.a == 1.0:
				note_explosions[notes_to_play_midi.find(midi_note)].emitting = true
		sampler_timer.start()
		await(sampler_timer.timeout)
	sampler_timer.start()
	await(sampler_timer.timeout)
	sampler_timer.start()
	await(sampler_timer.timeout)
	sampler_instrument.play_note("C", 4)
	sampler_instrument.play_note("E", 4)
	sampler_instrument.play_note("G", 4)
	sampler_instrument.play_note("C", 5)


func check_note() -> void:
	if snapped_note == current_note: # correct note played
		label_punctuality()
		# note go rainbow
		#current_note_label.text = rainbow_effect + current_note_label.text[-1]
		
		# set explosion position to note_label position with offset
		note_explosions[note_label_to_play_index].position = current_note_label.global_position + Vector2(20, 50)
		note_explosions[note_label_to_play_index].emitting = true
		
		if note_label_to_play_index < note_labels_to_play.size() - 1:
			note_label_to_play_index += 1
			# advance note_label
			current_note_label = note_labels_to_play[note_label_to_play_index]
			# make current note label visible
			current_note_label.modulate.a = 1.0
			# set current note to MusicTheoryDB-friendly string
			current_note = MusicTheoryDB.get_midi_pitch(current_note_label.get_parent().name.left(1) + "_String_" + current_note_label.text[-1])
		else:
			reset_notes_to_play()
			# add spawn bpmtick and add_child to latest if all perfect
			var bpm_tick_spawn = BPM_tick_label.instantiate()
			if $ClearedBPMsControl.get_children()[-1].get_child_count() == 0: # if no tick yet
				bpm_tick_spawn.position.x += 100
				$ClearedBPMsControl.get_children()[-1].add_child(bpm_tick_spawn)
			elif $ClearedBPMsControl.get_children()[-1].get_child_count() < 3: # if less than 3 ticks
				# set new tick 30 pixels to the right of latest tick
				bpm_tick_spawn.position.x = $ClearedBPMsControl.get_children()[-1].get_children()[-1].position.x + 30
				$ClearedBPMsControl.get_children()[-1].add_child(bpm_tick_spawn)
			else:
				Conductor.change_bpm(Conductor.bpm + 40.0)
				# Update main title BPM
				$TabBoxRichTextLabel/TitleRichTextLabel.text = $TabBoxRichTextLabel/TitleRichTextLabel.text.left(16) + str(Conductor.bpm/2)
				# add new cleared bpm
				var cleared_bpm_spawn = cleared_BPM_label.instantiate()
				cleared_bpm_spawn.text = "[b]" + str(Conductor.bpm/2)
				if $ClearedBPMsControl.get_child_count() > 0:
					cleared_bpm_spawn.position = $ClearedBPMsControl.get_children()[-1].position + Vector2(250, 0)
				$ClearedBPMsControl.add_child(cleared_bpm_spawn)
		$BouncingRhythmContainerNode/BouncingRhythmIndicator.move_horizontally_to(note_labels_to_play[note_label_to_play_index].global_position.x + 20.0)
		if current_note_label.get_parent().get_parent().get_parent().name == "UkuleleTab2":
			$BouncingRhythmContainerNode.position.y = 590.0
	else: # wrong note played
		if only_correct_notes_allowed:
			if $ClearedBPMsControl.get_children()[-1].get_child_count() > 0:
				$ClearedBPMsControl.get_children()[-1].get_children()[-1].queue_free()

		


func reset_notes_to_play() -> void:
	$BouncingRhythmContainerNode.position.y = 85
	note_label_to_play_index = 0
	current_note_label = note_labels_to_play[0]
	current_note = MusicTheoryDB.get_midi_pitch(current_note_label.get_parent().name.left(1) + "_String_" + current_note_label.text[-1])
	$BouncingRhythmContainerNode/BouncingRhythmIndicator.move_horizontally_to(note_labels_to_play[note_label_to_play_index].global_position.x + 20.0)

	for tween in success_tweens_array:
		tween.kill()
		
	for note_label in note_labels_to_play:
		note_label.add_theme_color_override("default_color", default_color)
		# show only first note
		if not note_label == current_note_label:
			note_label.modulate.a = 0
	
	for punctuality_label in $PunctualityLabelsControl.get_children():
		punctuality_label.queue_free()
		


func bounce_current_note_label() -> void:
	var tween = create_tween()
	var bounce_height = 20
	tween.set_trans(Tween.TRANS_QUAD)
	#tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(current_note_label, "position:y", position.y + bounce_height, Conductor.sec_per_beat).set_ease(Tween.EASE_IN)
	tween.tween_property(current_note_label, "position:y", position.y, Conductor.sec_per_beat).set_ease(Tween.EASE_OUT)
	tween.play()

var success_tweens_array = []
func success_glow() -> void:
	var max_glow := Color(0.5, 3.2, 0.5)
	var min_glow := Color(0.5, 1.5, 0.5)
	var tween_duration = Conductor.sec_per_beat
	var tween = create_tween()
	tween.set_loops()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(current_note_label, "theme_override_colors/default_color", min_glow, tween_duration).from(max_glow)
	tween.tween_property(current_note_label, "theme_override_colors/default_color", max_glow, tween_duration).from(min_glow)
	tween.play()
	success_tweens_array.append(tween)


func left_click(coordinates: Vector2):
	var press = InputEventMouseButton.new()
	press.set_button_index(MOUSE_BUTTON_LEFT)
	press.set_position(coordinates)
	press.set_pressed(true)
	Input.parse_input_event(press)
	sampler_timer.start()
	await(sampler_timer.timeout)
	var release = InputEventMouseButton.new()
	release.set_button_index(MOUSE_BUTTON_LEFT)
	release.set_position(coordinates)
	release.set_pressed(false)
	Input.parse_input_event(release)


func set_current_note_label(new_node: Control) -> void:
	current_note_label = new_node


func remove_tab_outlines(tab_to_clean: Control) -> void:
	for ukuelele_string in tab_to_clean.get_children():
		for control in ukuelele_string.get_children():
			if control.is_class("BoxContainer"):
				for note_label in control.get_children():
					note_label.add_theme_stylebox_override("normal", blank_style_box_flat)


func slide_in(object_to_slide: Node) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(object_to_slide, "position:x", 194, 0.5).from(400) # slide left
	tween = create_tween() # tween in parallel
	tween.tween_property(object_to_slide, "modulate:a", 1.0, 0.2).from(0.0) # fade in


func label_punctuality() -> void:
	var time_off_beat = Conductor.closest_beat_in_bar(Conductor.song_position_in_seconds)[1]
	print("time_off_beat: " + str(time_off_beat))
	print("closest beat in bar: " + str(Conductor.closest_beat_in_bar(Conductor.song_position_in_seconds)[0]))
	var punctuality := ""
	if Conductor.closest_beat_in_bar(Conductor.song_position_in_seconds)[0] % 2 != 0: # closest beat is down beat
		if time_off_beat > on_beat_window:
			if only_correct_notes_allowed:
				if $ClearedBPMsControl.get_children()[-1].get_child_count() > 0:
					$ClearedBPMsControl.get_children()[-1].get_children()[-1].queue_free()
		#if time_off_beat > Conductor.sec_per_beat / rhythm_tolerance: # time off beat is significant
			# divide by 4 because significant time off beat in "220" bpm seems to be 0.07 which is 25% of 0.2727 (60/220)
			punctuality = Conductor.closest_beat_in_song(Conductor.song_position_in_seconds)[2] # determine late or early
			if punctuality == "early": # moderate amount of time off before closest beat in bar 1,3,5,7
				current_note_label.add_theme_color_override("default_color", early_color)
				var early_label_spawn = early_label.instantiate()
				$PunctualityLabelsControl.add_child(early_label_spawn)
				early_label_spawn.position = current_note_label.global_position + Vector2(-70, 90)
			elif punctuality == "late": # moderate amount of time off after closest beat in bar 1,3,5,7
				current_note_label.add_theme_color_override("default_color", late_color)
				var late_label_spawn = late_label.instantiate()
				$PunctualityLabelsControl.add_child(late_label_spawn)
				late_label_spawn.position = current_note_label.global_position + Vector2(20, 90)
		else:
			punctuality = "perfect"
			if punctuality == "perfect": # very small amount of time off closest beat in bar 1,3,5,7
				success_glow()
				var perfect_label_spawn = perfect_label.instantiate()
				$PunctualityLabelsControl.add_child(perfect_label_spawn)
				perfect_label_spawn.position = current_note_label.global_position + Vector2(-50, 90)
	else: # closest beat is upbeat
		punctuality = Conductor.closest_beat_in_song(Conductor.song_position_in_seconds)[2]
		if only_correct_notes_allowed:
			if $ClearedBPMsControl.get_children()[-1].get_child_count() > 0:
				$ClearedBPMsControl.get_children()[-1].get_children()[-1].queue_free()
		if punctuality == "early": # moderate amount of time off before closest beat in bar 1,3,5,7
			current_note_label.add_theme_color_override("default_color", early_color)
			var early_label_spawn = early_label.instantiate()
			$PunctualityLabelsControl.add_child(early_label_spawn)
			early_label_spawn.position = current_note_label.global_position + Vector2(-70, 90)
		elif punctuality == "late": # moderate amount of time off after closest beat in bar 1,3,5,7
			current_note_label.add_theme_color_override("default_color", late_color)
			var late_label_spawn = late_label.instantiate()
			$PunctualityLabelsControl.add_child(late_label_spawn)
			late_label_spawn.position = current_note_label.global_position + Vector2(20, 90)
