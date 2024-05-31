extends Control

@export var octave: int = 5 # 0 to 8
signal note_played(pitch)
signal note_released(pitch)

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
#endregion
@onready var sampler:  SamplerInstrument = $SamplerInstrument
@onready var octave_label: RichTextLabel = $OctaveLabel
@onready var minus_button: Button = $MinusButton
@onready var plus_button: Button = $PlusButton
@onready var note_labels: Control = $NoteLabels


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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MidiListener.connect("midi_note_on", midi_key_down)
	MidiListener.connect("midi_note_off", midi_key_up)
	MidiListener.connect("qwerty_note_on", qwerty_key_down)
	MidiListener.connect("qwerty_note_off", qwerty_key_up)
	minus_button.connect("pressed", change_octave.bind("minus"))
	plus_button.connect("pressed", change_octave.bind("plus"))
	for label in note_labels.get_children():
		label.text += str(octave)


func midi_key_down(note_played :  int) -> void:
	print(note_played, " played")
	if pitch_node_dictionary.keys().has(note_played):
		pitch_node_dictionary[note_played].button_pressed = true
	var note_name := MusicTheoryDB.get_note_name(note_played)
	var octave:= MusicTheoryDB.get_note_octave(note_played)
	sampler.play_note(note_name, octave)


func midi_key_up(note_released : int) -> void:
	print(note_released, " released")
	if pitch_node_dictionary.keys().has(note_released):
		pitch_node_dictionary[note_released].button_pressed = false


func qwerty_key_down(note_played: int) -> void:
	note_played = note_played + 12 + (12 * octave)
	var note_value : int = note_played % 12
	var note_name := MusicTheoryDB.get_note_name(note_played)
	pitch_node_dictionary[note_value].button_pressed = true
	var note_octave := MusicTheoryDB.get_note_octave(note_played)
	sampler.play_note(note_name, note_octave)
	print(note_played, " played")
	emit_signal("note_played", note_played)


func qwerty_key_up(note_released : int) -> void:
	var note_value : int = note_released % 12
	pitch_node_dictionary[note_value].button_pressed = false
	note_released = note_released + 12 + (12 * octave)
	print(note_released, " released")
	emit_signal("note_released", note_released)


func change_octave(plus_or_minus: String) -> void:
	if plus_or_minus == "plus":
		octave += 1
	elif plus_or_minus == "minus":
		octave -= 1
	octave = clampi(octave, 0, 9)
	octave_label.text = "[center]Octave: " + str(octave)
	for label in note_labels.get_children():
		label.text = label.text.left(9)
		label.text += str(octave)
