extends Node

signal qwerty_note_on(note_played)
signal qwerty_note_off(note_played)

@export var lowest_C := 60 # C4

var action_pitch_dictionary: Dictionary = {
	"C_on": 0,
	"Csharp_on": 1,
	"D_on": 2,
	"Dsharp_on": 3,
	"E_on": 4,
	"F_on": 5,
	"Fsharp_on": 6,
	"G_on": 7,
	"Gsharp_on": 8,
	"A_on": 9,
	"Asharp_on": 10,
	"B_on": 11,
	"C_plus_on": 12,
	"Csharp_plus_on": 13,
	"D_plus_on": 14,
	"Dsharp_plus_on": 15,
	"E_plus_on": 16,
	"F_plus_on": 17,
	"Fsharp_plus_on": 18,
	"G_plus_on": 19,
	"Gsharp_plus_on": 20,
	"A_plus_on": 21,
	"Asharp_plus_on": 22,
	"B_plus_on": 23,
	"C_plus_plus_on": 24,
	"Csharp_plus_plus_on": 25,
	"D_plus_plus_on": 26,
	"Dsharp_plus_plus_on": 27,
	"E_plus_plus_on": 28,
	"F_plus_plus_on": 29,
}

func _ready() -> void:
	for key in action_pitch_dictionary:
		action_pitch_dictionary[key] += lowest_C


func _unhandled_input(event: InputEvent) -> void:
	for key in action_pitch_dictionary:
		if Input.is_action_just_pressed(key):
			emit_signal("qwerty_note_on", action_pitch_dictionary[key])
		elif Input.is_action_just_released(key):
			emit_signal("qwerty_note_off", action_pitch_dictionary[key])
