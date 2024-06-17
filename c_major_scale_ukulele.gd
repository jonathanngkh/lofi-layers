extends Control

@onready var a_string_note_container: BoxContainer = $TabBoxRichTextLabel/UkuleleTab/AString/AStringNoteContainer
@onready var e_string_note_container: BoxContainer = $TabBoxRichTextLabel/UkuleleTab/EString/EStringNoteContainer
@onready var c_string_note_container: BoxContainer = $TabBoxRichTextLabel/UkuleleTab/CString/CStringNoteContainer
@onready var g_string_note_container: BoxContainer = $TabBoxRichTextLabel/UkuleleTab/GString/GStringNoteContainer
@onready var note_containers := [g_string_note_container, c_string_note_container, e_string_note_container, a_string_note_container]
@onready var blank_style_box_flat = preload("res://assets/themes/blank_style_box_flat.tres")
@onready var character: TextureRect = $Character
@onready var dialogue_rich_text_label: RichTextLabel = $DialogueRichTextLabel
@onready var next_button: Button = $NextButton
@onready var talking_synth: AudioStreamPlayer = $TalkingSynth
@onready var talking_timer: Timer = $TalkingTimer
@onready var ukulele_tab: Control = $TabBoxRichTextLabel/UkuleleTab
@onready var sampler_instrument: SamplerInstrument = $SamplerInstrument
@onready var sampler_timer: Timer = $SamplerTimer

# expressionsL happy, regular, determined, euphoric, sad, angry
var dialogue_items : Array[Dictionary] = [
	{"text": "[b]Harmonious[/b] Hellos, Amy!",
	"expression": "happy"},
	
	{"text": "I'm Pink. I'll be your scales practice coach.",
	"expression": "regular"},
	
	{"text": "Let's get great at ukulele together!",
	"expression": "determined"},
	
	{"text": "Watch what happens when you play the note that's [wave amp=80 freq=20]bouncing![/wave] [i](Pluck the C string)[/i]",
	"expression": "determined"},
	
	{"text": "It turns [rainbow]rainbow-colored[/rainbow]! It's happy you played it.",
	"expression": "happy"},
	
	{"text": "Now, play all the [wave amp=80 freq=20]bouncing[/wave] notes as they appear.",
	"expression": "determined"},
	
	{"text": "You did it!",
	"expression": "happy"},
]

var wave_effect := "[wave amp=100 freq=20]"
var rainbow_effect := "[rainbow]"
var shake_effect := "[shake]"
var pulse_effect := "[pulse]"
var fade_effect := "[fade]"
var tornado_effect := "[tornado]"

@export var pink_pitch_scale := 0.9
@export var seconds_per_character := 0.4/18.0
@export var current_dialogue_index: int = 0
@onready var current_item: Dictionary = dialogue_items[current_dialogue_index]
@onready var text_appearing_duration: float = current_item["text"].length() * seconds_per_character
var talking_playback_position := 0.0
@onready var note_labels_to_play: Array[Control] = get_note_labels_to_play(ukulele_tab)
@onready var note_label_to_play_index := 0
var notes_to_play_midi: Array[int]
@onready var current_note_label = note_labels_to_play[note_label_to_play_index]
@onready var current_note = MusicTheoryDB.get_midi_pitch(current_note_label.get_parent().name.left(1) + "_String_" + current_note_label.text[-1])
@onready var note_explosion := preload("res://assets/vfx/note_explosion_cpu_particles_2d.tscn")
var is_checking_notes = false
var snapped_note # converted detected pitch note for checking
var note_explosions := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PitchDetector.connect("detected_pitch", _on_pitch_detector_note_detected)
	reset_tabs()
	next_button.connect("pressed", _on_next_button_button_pressed)
	talking_timer.connect("timeout", _on_talking_timer_timeout)
	talk()
	show_text()
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


func get_note_labels_to_play(from_ukulele_tab: Control) -> Array[Control]:
	for string in from_ukulele_tab.get_children():
		for control in string.get_children():
			if control.is_class("BoxContainer"): #notecontainer
				for note_label in control.get_children():
					if not note_label.text == "":
						note_labels_to_play.append(note_label)
	note_labels_to_play.sort_custom(func(a, b): return a.name.naturalnocasecmp_to(b.name) < 0)
	return note_labels_to_play


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
	for note_midi in notes_to_play_midi:
		if snapped_note == note_midi:
			# if note_label is visible:
			if note_labels_to_play[notes_to_play_midi.find(snapped_note)].modulate.a == 1.0:
				note_explosions[notes_to_play_midi.find(snapped_note)].emitting = true


func play_all_notes() -> void:
	for midi_note in notes_to_play_midi:
		sampler_instrument.play_note(str(MusicTheoryDB.get_note_name(midi_note)), MusicTheoryDB.get_note_octave(midi_note))
		sampler_timer.start()
		await(sampler_timer.timeout)


func check_note() -> void:
	if snapped_note == current_note:
		if current_note == notes_to_play_midi[0]:
			if next_button.disabled == true:
				next_button.disabled = false
				next_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
				left_click(Vector2(2120, 1190))
		# note go rainbow
		current_note_label.text = rainbow_effect + current_note_label.text[-1]
		# set explosion position to note_label position with offset
		note_explosions[note_label_to_play_index].position = current_note_label.global_position + Vector2(20, 50)
		
		if current_note == notes_to_play_midi[-1]:
			if next_button.disabled == true:
				next_button.disabled = false
				next_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
				sampler_timer.start()
				await(sampler_timer.timeout)
				left_click(Vector2(2120, 1190))
			
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


func reset_tabs() -> void:
	for note_container in note_containers:
		for note_label in note_container.get_children():
			#note_label.text = "1"
			note_label.add_theme_stylebox_override("normal", blank_style_box_flat) # remove tab_note border
			#note_label.text = wave_string + note_label.text


func _on_next_button_button_pressed() -> void:
	advance_dialogue()
	slide_in()
	next_button.button_pressed = false
	if current_dialogue_index == 6:
		play_all_notes()


func slide_in() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(character, "position:x", 194, 0.5).from(400) # slide left
	
	tween = create_tween() # tween in parallel
	tween.tween_property(character, "modulate:a", 1.0, 0.2).from(0.0) # fade in


func advance_dialogue() -> void:
	if current_dialogue_index + 1 < dialogue_items.size():
		current_dialogue_index += 1
	show_text()
	is_checking_notes = false


func _on_talking_timer_timeout() -> void:
	talking_playback_position = talking_synth.get_playback_position()
	talking_synth.stop()
	if current_dialogue_index == 3 or current_dialogue_index == 5:
		is_checking_notes = true
		next_button.disabled = true
		next_button.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
	else:
		if not current_dialogue_index == dialogue_items.size() - 1: # last index
			$NextButton/ButtonUpSound.play()
			next_button.disabled = false
			next_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func talk() -> void:
	text_appearing_duration = float(current_item["text"].length()) * seconds_per_character
	talking_timer.wait_time = text_appearing_duration
	talking_synth.pitch_scale = pink_pitch_scale
	talking_synth.play(talking_playback_position)
	talking_timer.start()
	next_button.disabled = true
	next_button.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN


func show_text() -> void:
	current_item = dialogue_items[current_dialogue_index]
	dialogue_rich_text_label.text = current_item["text"]
	character.expression = current_item["expression"]
	talk()
	var tween = create_tween()
	tween.tween_property(dialogue_rich_text_label, "visible_ratio", 1, text_appearing_duration).from(0.0)
