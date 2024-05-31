extends Node

const NOTE_LENGTHS = {
	DOTTED_SEMIBREVE = 64 * 1.5,
	SEMIBREVE = 64,
	
	DOTTED_MINIM = 32 * 1.5,
	MINIM = 32,
	
	DOTTED_CROTCHET = 16 * 1.5,
	CROTCHET = 16,
	
	DOTTED_QUAVER = 8 * 1.5,
	QUAVER = 8,
	
	DOTTED_SEMIQUAVER = 4 * 1.5,
	SEMIQUAVER = 4,
	
	DOTTED_DEMISEMIQUAVER = 2 * 1.5,
	DEMISEMIQUAVER = 2,
	
	DOTTED_HEMIDEMISEMIQUAVER = 1.5,
	HEMIDEMISEMIQUAVER = 1,
}

var english_mode: bool = false

var PITCHES: Dictionary = _get_midi_dictionary()

#region pitches
#const PITCHES = { "A0": 21,"A#0":22,"B0":23,"C1":24,"C#1":25,"D1":26,"D#1":27,"E1":28,"F1":29,"F#1":30,"G1":31,"G#1":32,"A1":33,"A#1":34,"B1":35,"C2":36,"C#2":37,"D2":38,"D#2":39,"E2":40,"F2":41,"F#2":42,"G2":43,"G#2":44,"A2":45,"A#2":46,"B2":47,"C3":48,"C#3":49,"D3":50,"D#3":51,"E3":52,"F3":53,"F#3":54,"G3":55,"G#3":56,"A3":57,"A#3":58,"B3":59,"C4":60,"C#4":61,"D4":62,"D#4":63,"E4":64,"F4":65,"F#4":66,"G4":67,"G#4":68,"A4":69,"A#4":70,"B4":71,"C5":72,"C#5":73,"D5":74,"D#5":75,"E5":76,"F5":77,"F#5":78,"G5":79,"G#5":80,"A5":81,"A#5":82,"B5":83,"C6":84,"C#6":85,"D6":86,"D#6":87,"E6":88,"F6":89,"F#6":90,"G6":91,"G#6":92,"A6":93,"A#6":94,"B6":95,"C7":96,"C#7":97,"D7":98,"D#7":99,"E7":100,"F7":101,"F#7":102,"G7":103,"G#7":104,"A7":105,"A#7":106,"B7":107,"C8":108 }
#endregion


func _get_midi_dictionary() -> Dictionary:
	# Define the note patterns within an octave
	var notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
	# Create the dictionary
	var midi_dict = {}
	# Start at MIDI note 21 (A0) and end at MIDI note 108 (C8)
	for pitch in range(21, 109):
		var note_index = (pitch - 12) % 12  # Calculate the note index in the 'notes' list
		var octave = (pitch - 12) / 12  # Calculate the octave
		var note_name = "%s%d" % [notes[note_index], octave]  # Combine note and octave
		if english_mode:
			midi_dict[note_name] = pitch
		else:
			midi_dict[pitch] = note_name  # Map MIDI number to note name
	return midi_dict


var note_values := {
	"C": 0,
	"C#": 1,
	"Db": 1,
	"D": 2,
	"D#": 3,
	"Eb": 3,
	"E": 4,
	"E#": 5,
	"Fb": 4,
	"F": 5,
	"F#": 6,
	"Gb": 6,
	"G": 7,
	"G#": 8,
	"Ab": 8,
	"A": 9,
	"A#": 10,
	"Bb": 10,
	"B": 11,
	"B#": 12,
	"Cb": -1
}

# Return the number value of a note from its name and octave (where C0 is 0)
func get_note_value(tone: String, octave: int = 4) -> int:
	if !note_values.has(tone):
		push_error("'" + str(tone) + "' is not a valid note!")
		return 0
	var value: int = note_values[tone]
	return value + 12 * octave

# Return the name of a note from its value
func get_note_name(value: int) -> String:
	var notes := note_values.keys()
	var values := note_values.values()
	var index: int = values.find(value % 12)
	return notes[index]

# Return the octave of a note from its value
func get_note_octave(value: int) -> int:
	return (value - 12) / 12
