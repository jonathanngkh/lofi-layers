extends Node

signal qwerty_note_on(note_played)
signal qwerty_note_off(note_released)

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
	# set each value to the assigned octave
	for key in action_pitch_dictionary:
		action_pitch_dictionary[key] += lowest_C


func _unhandled_input(_event: InputEvent) -> void:
	# sending pitches according to input map
	for key in action_pitch_dictionary:
		if Input.is_action_just_pressed(key):
			qwerty_note_on.emit(action_pitch_dictionary[key])
			#emit_signal("qwerty_note_on", action_pitch_dictionary[key])
		elif Input.is_action_just_released(key):
			qwerty_note_off.emit(action_pitch_dictionary[key])
			#emit_signal("qwerty_note_off", action_pitch_dictionary[key])
	
	# Changing octaves using arrow keys
	if Input.is_action_just_released("qwerty_minus_1_octave"):
		# reset pitches to 0-12
		for key in action_pitch_dictionary:
			action_pitch_dictionary[key] -= lowest_C
		# lower the lowest note
		lowest_C -= 12
		# clamp lowest_C to C1 to C8
		lowest_C = clampi(lowest_C, 24, 108)
		print('lowest C lowered to: ', MusicTheoryDB.get_note_name(lowest_C), MusicTheoryDB.get_note_octave(lowest_C), ", ", lowest_C)
		# change the pitches according to the new lowest_c
		for key in action_pitch_dictionary:
			action_pitch_dictionary[key] += lowest_C

	elif  Input.is_action_just_released("qwerty_plus_1_octave"):
		for key in action_pitch_dictionary:
			action_pitch_dictionary[key] -= lowest_C
		lowest_C += 12
		lowest_C = clampi(lowest_C, 24, 132) # C1 to C10
		print('lowest C raised to: ', MusicTheoryDB.get_note_name(lowest_C), MusicTheoryDB.get_note_octave(lowest_C), ", ", lowest_C)
		for key in action_pitch_dictionary:
			action_pitch_dictionary[key] += lowest_C
