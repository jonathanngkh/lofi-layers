extends Control

#@onready var midi_listener: Control = $MidiListener
@onready var note_head: TextureRect = $TextBox/Staff/NoteHead
@onready var piano: Control = $Piano


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MidiListener.connect("note_on", _on_midi_listener_note_on)
	MidiListener.connect("note_off", _on_midi_listener_note_off)
	note_head.modulate = "00bf4b"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_midi_listener_note_on(note_played: int) -> void:
	#note_head.modulate = "00bf4b"
	if note_played == 72:
		note_head.material.set_shader_parameter("strength", 1.0)
		#$Piano/HBoxContainer/C_TextureButton.button_pressed = true
	#if note_played == 73:
		#$Piano/C_Sharp_BaseRect/C_Sharp_TextureButton.button_pressed = true
	#note_head.scale = Vector2(1.2, 1.2)


func _on_midi_listener_note_off(note_released: int) -> void:
	if note_released == 72:
		note_head.material.set_shader_parameter("strength", 0.0)
		#$Piano/HBoxContainer/C_TextureButton.button_pressed = false
	#if note_released == 73:
		#$Piano/C_Sharp_BaseRect/C_Sharp_TextureButton.button_pressed = false
	#note_head.modulate = "ffffff"
	#note_head.scale = Vector2(1.0, 1.0)
