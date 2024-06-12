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

var midi_frequency_dictionary = {
	0: 8.176, 1: 8.662, 2: 9.177, 3: 9.723, 4: 10.301,
	5: 10.913, 6: 11.562, 7: 12.250, 8: 12.978, 9: 13.750,
	10: 14.568, 11: 15.434, 12: 16.352, 13: 17.324, 14: 18.354,
	15: 19.445, 16: 20.602, 17: 21.827, 18: 23.125, 19: 24.500,
	20: 25.957, 21: 27.500, 22: 29.135, 23: 30.868, 24: 32.703,
	25: 34.648, 26: 36.708, 27: 38.891, 28: 41.203, 29: 43.654,
	30: 46.249, 31: 48.999, 32: 51.913, 33: 55.000, 34: 58.270,
	35: 61.735, 36: 65.406, 37: 69.296, 38: 73.416, 39: 77.782,
	40: 82.407, 41: 87.307, 42: 92.499, 43: 97.999, 44: 103.826,
	45: 110.000, 46: 116.541, 47: 123.471, 48: 130.813, 49: 138.591,
	50: 146.832, 51: 155.563, 52: 164.814, 53: 174.614, 54: 184.997,
	55: 195.998, 56: 207.652, 57: 220.000, 58: 233.082, 59: 246.942,
	60: 261.626, 61: 277.183, 62: 293.665, 63: 311.127, 64: 329.628,
	65: 349.228, 66: 369.994, 67: 391.995, 68: 415.305, 69: 440.000,
	70: 466.164, 71: 493.883, 72: 523.251, 73: 554.365, 74: 587.330,
	75: 622.254, 76: 659.255, 77: 698.456, 78: 739.989, 79: 783.991,
	80: 830.609, 81: 880.000, 82: 932.328, 83: 987.767, 84: 1046.502,
	85: 1108.731, 86: 1174.659, 87: 1244.508, 88: 1318.510, 89: 1396.913,
	90: 1479.978, 91: 1567.982, 92: 1661.219, 93: 1760.000, 94: 1864.655,
	95: 1975.533, 96: 2093.005, 97: 2217.461, 98: 2349.318, 99: 2489.016,
	100: 2637.020, 101: 2793.826, 102: 2959.955, 103: 3135.963, 104: 3322.438,
	105: 3520.000, 106: 3729.310, 107: 3951.066, 108: 4186.009, 109: 4434.922,
	110: 4698.636, 111: 4978.032, 112: 5274.041, 113: 5587.652, 114: 5919.911,
	115: 6271.927, 116: 6644.875, 117: 7040.000, 118: 7458.620, 119: 7902.133,
	120: 8372.018, 121: 8869.844, 122: 9397.273, 123: 9956.063, 124: 10548.082,
	125: 11175.303, 126: 11839.822, 127: 12543.854
}

func _get_midi_dictionary() -> Dictionary:
	# Define the note patterns within an octave
	var notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
	# Create the dictionary
	var midi_dict = {}
	# Start at MIDI note 21 (A0) and end at MIDI note 108 (C8)
	for pitch in range(21, 109):
		var note_index = (pitch - 12) % 12  # Calculate the note index in the 'notes' list
		var octave = (pitch - 12) / floor(12)  # Calculate the octave
		var note_name = "%s%d" % [notes[note_index], octave]  # Combine note and octave
		if english_mode:
			midi_dict[note_name] = pitch # Map note name to MIDI number
		else:
			midi_dict[pitch] = note_name  # Map MIDI number to note name
	return midi_dict


var note_values := {
	"C": 0,
	"C#": 1,
	#"Db": 1,
	"D": 2,
	"D#": 3,
	#"Eb": 3,
	"E": 4,
	#"E#": 5,
	#"Fb": 4,
	"F": 5,
	"F#": 6,
	#"Gb": 6,
	"G": 7,
	"G#": 8,
	#"Ab": 8,
	"A": 9,
	"A#": 10,
	#"Bb": 10,
	"B": 11,
	#"B#": 12,
	#"Cb": -1
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
	return (value - 12) / floor(12)
