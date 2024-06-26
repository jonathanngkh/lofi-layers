extends Control

@export var octave: int = 5 # 0 to 8
@export var sound_on: bool = true
@export var echo_on: bool = false
@export var debug_mode_on: bool = false

signal note_played_signal(pitch)
signal note_released_signal(pitch)

#region onready variables
@onready var c_texture_button: TextureButton = %CTextureButton
@onready var d_texture_button: TextureButton = %DTextureButton
@onready var e_texture_button: TextureButton = %ETextureButton
@onready var f_texture_button: TextureButton = %FTextureButton
@onready var g_texture_button: TextureButton = %GTextureButton
@onready var a_texture_button: TextureButton = %ATextureButton
@onready var b_texture_button: TextureButton = %BTextureButton
@onready var c_sharp_texture_button: TextureButton = %CSharpTextureButton
@onready var d_sharp_texture_button: TextureButton = %DSharpTextureButton
@onready var f_sharp_texture_button: TextureButton = %FSharpTextureButton
@onready var g_sharp_texture_button: TextureButton = %GSharpTextureButton
@onready var a_sharp_texture_button: TextureButton = %ASharpTextureButton
@onready var sampler:  SamplerInstrument = $SamplerInstrument
@onready var octave_label: RichTextLabel = $OctaveLabel
@onready var minus_button: Button = $MinusButton
@onready var plus_button: Button = $PlusButton
@onready var note_labels: Control = $NoteLabels
@onready var toggle_note_names_button: Button = $ToggleNoteNamesButton
#endregion


@onready var pitch_node_dictionary: Dictionary = {
	0: c_texture_button,
	1: c_sharp_texture_button,
	2: d_texture_button,
	3: d_sharp_texture_button,
	4: e_texture_button,
	5: f_texture_button,
	6: f_sharp_texture_button,
	7: g_texture_button,
	8: g_sharp_texture_button,
	9: a_texture_button,
	10: a_sharp_texture_button,
	11: b_texture_button,
}

var angle_to_set = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RainbowRotationTimer.timeout.connect(func() -> void: angle_to_set += 1; c_texture_button.material.set_shader_parameter("angle", angle_to_set))
	toggle_note_names_button.connect("pressed", func() -> void: note_labels.visible = !note_labels.visible)
	MidiListener.connect("midi_note_on", midi_key_down)
	MidiListener.connect("midi_note_off", midi_key_up)
	QwertyListener.connect("qwerty_note_on", qwerty_key_down)
	QwertyListener.connect("qwerty_note_off", qwerty_key_up)
	PitchDetector.connect("detected_pitch", detector_key_down)
	minus_button.connect("pressed", change_octave.bind("minus"))
	plus_button.connect("pressed", change_octave.bind("plus"))
	
	for label in note_labels.get_children():
		label.text += str(octave)
	octave_label.text += str(octave)


func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_CAPSLOCK):
		print('toggled note name visibility')
		note_labels.visible = !note_labels.visible


func detector_key_down(note_heard: String) -> void:
	
	var note_heard_float := float(note_heard)
	var snapped_note = snapped(note_heard_float, 1)
	#print("piano heard note ", str(snapped_note))
	var note_name := MusicTheoryDB.get_note_name(snapped_note)
	var note_octave:= MusicTheoryDB.get_note_octave(snapped_note) + 1
	if echo_on:
		if sound_on:
			sampler.play_note(note_name, note_octave)
		var note_value : int = snapped_note % 12
		if note_octave == octave:
			pitch_node_dictionary[note_value].button_pressed = true
		note_played_signal.emit(snapped_note)
	# need to experiment with playing the note only on high confidence
	# and play note only on new amplitude spike. check aubio functions
	# if "repeated" notes, need to treat as 1 long note held down. and 0 detected as note up


func midi_key_down(note_played: int) -> void:
	if debug_mode_on:
		print(MusicTheoryDB.get_note_name(note_played), MusicTheoryDB.get_note_octave(note_played), " played (midi)")
	var note_name := MusicTheoryDB.get_note_name(note_played)
	var note_octave:= MusicTheoryDB.get_note_octave(note_played)
	if sound_on:
		sampler.play_note(note_name, note_octave)
	var note_value : int = note_played % 12
	if note_octave == octave:
		pitch_node_dictionary[note_value].button_pressed = true
	note_played_signal.emit(note_played)


func midi_key_up(note_released: int) -> void:
	if debug_mode_on:
		print(note_released, " released (midi)")
	#if pitch_node_dictionary.keys().has(note_released):
		#pitch_node_dictionary[note_released].button_pressed = false
	var note_octave:= MusicTheoryDB.get_note_octave(note_released)
	var note_value : int = note_released % 12
	if note_octave == octave:
		pitch_node_dictionary[note_value].button_pressed = false
	note_released_signal.emit(note_released)


func qwerty_key_down(note_played: int) -> void:
	var note_value : int = note_played % 12 # convert to 0-12 for MusicTheoryDB processing
	var note_name := MusicTheoryDB.get_note_name(note_played)
	var note_octave := MusicTheoryDB.get_note_octave(note_played)
	if note_octave == octave:
		pitch_node_dictionary[note_value].button_pressed = true
	if sound_on:
		sampler.play_note(note_name, note_octave)
	if debug_mode_on:
		print(MusicTheoryDB.get_note_name(note_played), MusicTheoryDB.get_note_octave(note_played), " played (qwerty)")
	note_played_signal.emit(note_played)


func qwerty_key_up(note_released: int) -> void:
	var note_value: int = note_released % 12
	var note_octave := MusicTheoryDB.get_note_octave(note_released)
	if note_octave == octave:
		pitch_node_dictionary[note_value].button_pressed = false
	if debug_mode_on:
		print(note_released, " released (qwerty)")
	note_released_signal.emit(note_released)


func change_octave(plus_or_minus: String) -> void:
	var min_octave = 0
	var max_octave = 8
	if plus_or_minus == "plus":
		octave += 1
	elif plus_or_minus == "minus":
		octave -= 1
	octave = clampi(octave, min_octave, max_octave)
	
	minus_button.disabled = true if octave == min_octave else false
	plus_button.disabled = true if octave == max_octave else false
	
	octave_label.text = octave_label.text.left(-1) + str(octave)
	for label in note_labels.get_children():
		label.text = label.text.left(-1) + str(octave)
