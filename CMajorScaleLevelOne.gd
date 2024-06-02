extends Control

#@onready var midi_listener: Control = $MidiListener
@onready var note_head: TextureRect = $TextBox/Staff/NoteHead
@onready var piano: Control = $PianoCanvasGroup/HBoxContainer/Piano



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	piano.note_played_signal.connect(_on_midi_listener_note_on)
	piano.note_released_signal.connect(_on_midi_listener_note_off)
	note_head.modulate = "00bf4b"


func _on_midi_listener_note_on(note_played: int) -> void:
	if note_played == 72:
		note_head.material.set_shader_parameter("strength", 1.0)


func _on_midi_listener_note_off(note_released: int) -> void:
	if note_released == 72:
		note_head.material.set_shader_parameter("strength", 0.0)
