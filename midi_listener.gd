#scales/arpgeggios practicer
#
#1) just the notes, any order.
#2) the notes in order
#3) the notes in order at a fixed speed
#4) the notes in order at an increasing speed
#5) the notes with dotted rhythm
#6) the notes with reverse dotted rhythm
#7) the notes in order in triplets
#8) the notes but as a lick

extends Node

signal midi_note_on(note_played)
signal midi_note_off(note_released)
signal qwerty_note_on(note_played)
signal qwerty_note_off(note_played)

var midi_dictionary: Dictionary = MusicTheoryDB.PITCHES
#@export var required_notes: MusicSegment = generate_music_segment(C_MAJOR_SCALE)
# where musicsegment is a class which is an array of notes and pace
# where note is a class with properties for pitch and rhythm

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
}


func _ready() -> void:
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
	#print(midi_dictionary)
	


func _process(_delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMIDI:
		if event.message == MIDI_MESSAGE_NOTE_ON:
			#print(midi_dictionary[event.pitch] + " on")
			emit_signal("midi_note_on", event.pitch)
		if event.message == MIDI_MESSAGE_NOTE_OFF:
			#print(midi_dictionary[event.pitch] + " off")
			emit_signal("midi_note_off", event.pitch)
			
	# QWERTY INPUTS
	for key in action_pitch_dictionary:
		if Input.is_action_just_pressed(key):
			emit_signal("qwerty_note_on", action_pitch_dictionary[key])
		elif Input.is_action_just_released(key):
			emit_signal("qwerty_note_off", action_pitch_dictionary[key])


func _print_midi_info(midi_event: InputEventMIDI):
	#msg 9 is note on. msg 8 is note off. pitch 0 is idle msg
	if (midi_event.pitch != 0 && midi_event.message == 9):
		print(midi_event)
	#print("Channel " + str(midi_event.channel))
	#print("Message " + str(midi_event.message))
	#print("Pitch " + str(midi_event.pitch))
	#print("Velocity " + str(midi_event.velocity))
	#print("Instrument " + str(midi_event.instrument))
	#print("Pressure " + str(midi_event.pressure))
	#print("Controller number: " + str(midi_event.controller_number))
	#print("Controller value: " + str(midi_event.controller_value))



func _get_midi_dictionary() -> Dictionary:
	# -> {"C5": 72...}
	# Define the note patterns within an octave
	var notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
	# Create the dictionary
	var midi_dict = {}
	# Start at MIDI note 21 (A0) and end at MIDI note 108 (C8)
	for pitch in range(21, 109):
		var note_index = (pitch - 12) % 12  # Calculate the note index in the 'notes' list
		var octave = (pitch - 12) / floor(12)  # Calculate the octave
		var note_name = "%s%d" % [notes[note_index], octave]  # Combine note and octave
		midi_dict[note_name] = pitch  # Map note name to MIDI number
	return midi_dict


#func _get_midi_dictionary() -> Dictionary:
	## Define the note patterns within an octave
	#var notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
	## Create the dictionary
	#var midi_dict = {}
	## Start at MIDI note 21 (A0) and end at MIDI note 108 (C8)
	#for pitch in range(21, 109):
		#var note_index = (pitch - 12) % 12  # Calculate the note index in the 'notes' list
		#var octave = (pitch - 12) / 12  # Calculate the octave
		#var note_name = "%s%d" % [notes[note_index], octave]  # Combine note and octave
		#midi_dict[pitch] = note_name  # Map MIDI number to note name
	#return midi_dict
