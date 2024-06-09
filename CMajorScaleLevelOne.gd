extends Control

#@onready var midi_listener: Control = $MidiListener

#region onready variables
@onready var note_head: TextureRect = $TextBox/Staff/NoteHead
@onready var piano: Control = $PianoCanvasGroup/HBoxContainer/Piano
@onready var note_heads: Control = $TextBox2/Staff/NoteHeads
@onready var c_4: TextureRect = $TextBox2/Staff/NoteHeads/C4
@onready var d_4: TextureRect = $TextBox2/Staff/NoteHeads/D4
@onready var e_4: TextureRect = $TextBox2/Staff/NoteHeads/E4
@onready var f_4: TextureRect = $TextBox2/Staff/NoteHeads/F4
@onready var g_4: TextureRect = $TextBox2/Staff/NoteHeads/G4
@onready var a_4: TextureRect = $TextBox2/Staff/NoteHeads/A4
@onready var b_4: TextureRect = $TextBox2/Staff/NoteHeads/B4
@onready var c_5: TextureRect = $TextBox2/Staff/NoteHeads/C5
@onready var d_5: TextureRect = $TextBox2/Staff/NoteHeads/D5
@onready var e_5: TextureRect = $TextBox2/Staff/NoteHeads/E5
@onready var f_5: TextureRect = $TextBox2/Staff/NoteHeads/F5
@onready var g_5: TextureRect = $TextBox2/Staff/NoteHeads/G5
@onready var a_5: TextureRect = $TextBox2/Staff/NoteHeads/A5
#endregion

@onready var pitch_note_head_dictionary: Dictionary = {
	60: c_4,
	62: d_4,
	64: e_4,
	65: f_4,
	67: g_4,
	69: a_4,
	71: b_4,
	72: c_5,
	74: d_5,
	76: e_5,
	77: f_5,
	79: g_5,
	81: a_5
}

@export var note_octaves_on = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	piano.note_played_signal.connect(_on_midi_listener_note_on)
	piano.note_released_signal.connect(_on_midi_listener_note_off)
	note_head.modulate = "00bf4b"
	for notehead in note_heads.get_children():
		notehead.visible = false


func _on_midi_listener_note_on(note_played: int) -> void:
	if note_played == 72:
		note_head.material.set_shader_parameter("strength", 1.0)
	for key in pitch_note_head_dictionary:
		if note_played == key:
			pitch_note_head_dictionary[key].visible = true
			if note_octaves_on:
				$TextBox2.text += MusicTheoryDB.get_note_name(key) + str(MusicTheoryDB.get_note_octave(key))
			else:
				$TextBox2.text += MusicTheoryDB.get_note_name(key)


func _on_midi_listener_note_off(note_released: int) -> void:
	if note_released == 72:
		note_head.material.set_shader_parameter("strength", 0.0)
	for key in pitch_note_head_dictionary:
		if note_released == key:
			pitch_note_head_dictionary[key].visible = false
			$TextBox2.text = $TextBox2.text.left(11)
