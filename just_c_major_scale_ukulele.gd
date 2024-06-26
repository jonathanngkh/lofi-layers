extends Control

@export var using_aubio: bool = false
@export var using_qwerty: bool = true
@export var using_midi: bool = false

@onready var blank_style_box_flat = preload("res://assets/themes/blank_style_box_flat.tres")
@onready var ukulele_tab: Control = $TabBoxRichTextLabel/UkuleleTab
@onready var ukulele_tab_2: Control = $TabBoxRichTextLabel/UkuleleTab2
@onready var sampler_instrument: SamplerInstrument = $SamplerInstrument
@onready var sampler_timer: Timer = $SamplerTimer

var wave_effect := "[wave amp=100 freq=20]"
var rainbow_effect := "[rainbow]"
var shake_effect := "[shake]"
var pulse_effect := "[pulse]"
var fade_effect := "[fade]"
var tornado_effect := "[tornado]"

@onready var note_labels_to_play: Array[Control]
@onready var note_label_to_play_index := 0
var notes_to_play_midi: Array[int]
@onready var current_note_label: Control
@onready var current_note: int
@onready var note_explosion := preload("res://assets/vfx/note_explosion_cpu_particles_2d.tscn")
var is_checking_notes = true
var snapped_note # converted detected pitch note for checking
var note_explosions := []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pitch_detector_note_detected(note_detected) -> void:
	if is_checking_notes:
		# convert string pitch detected 44.4 to int 44
		snapped_note = snapped(float(note_detected), 1)
		print(snapped_note)
		check_note()
	# check explosions
	#for note_midi in notes_to_play_midi:
		#if snapped_note == note_midi:
			## if note_label is visible:
			#if note_labels_to_play[notes_to_play_midi.find(snapped_note)].modulate.a == 1.0:
				#note_explosions[notes_to_play_midi.find(note_midi, 7)].emitting = true


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
	if snapped_note == current_note:
		# note go rainbow
		current_note_label.text = rainbow_effect + current_note_label.text[-1]
		# set explosion position to note_label position with offset
		note_explosions[note_label_to_play_index].position = current_note_label.global_position + Vector2(20, 50)
		note_explosions[note_label_to_play_index].emitting = true
			
		if note_label_to_play_index < note_labels_to_play.size() - 1:
			note_label_to_play_index += 1
			# advance note_label
			current_note_label = note_labels_to_play[note_label_to_play_index]
			# fade in current note label
			var tween = create_tween()
			tween.tween_property(current_note_label, "modulate:a", 1.0, 0.2).from(0.0)
			# make note bounce
			current_note_label.text = wave_effect + current_note_label.text[-1]
			# set current note to MusicTheoryDB-friendly string
			current_note = MusicTheoryDB.get_midi_pitch(current_note_label.get_parent().name.left(1) + "_String_" + current_note_label.text[-1])


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
