extends Control

var midi_dictionary: Dictionary = get_midi_dictionary()

func get_midi_dictionary():
	# Define the note patterns within an octave
	var notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
	# Create the dictionary
	var midi_dict = {}
	# Start at MIDI note 21 (A0) and end at MIDI note 108 (C8)
	for pitch in range(21, 109):
		var note_index = (pitch - 12) % 12  # Calculate the note index in the 'notes' list
		var octave = (pitch - 12) / 12  # Calculate the octave
		var note_name = "%s%d" % [notes[note_index], octave]  # Combine note and octave
		midi_dict[pitch] = note_name  # Map MIDI number to note name
	return midi_dict

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
	print(midi_dictionary[61])
	#print(midi_dictionary)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMIDI:
		if event.message == MIDI_MESSAGE_NOTE_ON:
			print(midi_dictionary[event.pitch])
		if event.message == MIDI_MESSAGE_NOTE_OFF:
			print(midi_dictionary[event.pitch])


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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
