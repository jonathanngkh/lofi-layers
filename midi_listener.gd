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

var midi_dictionary: Dictionary = MusicTheoryDB.PITCHES
#@export var required_notes: MusicSegment = generate_music_segment(C_MAJOR_SCALE)
# where musicsegment is a class which is an array of notes and pace
# where note is a class with properties for pitch and rhythm


func _ready() -> void:
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMIDI:
		if event.message == MIDI_MESSAGE_NOTE_ON:
			#print(midi_dictionary[event.pitch] + " on")
			midi_note_on.emit(event.pitch)
			#emit_signal("midi_note_on", event.pitch)
		if event.message == MIDI_MESSAGE_NOTE_OFF:
			#print(midi_dictionary[event.pitch] + " off")
			midi_note_off.emit(event.pitch)
			#emit_signal("midi_note_off", event.pitch)


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
