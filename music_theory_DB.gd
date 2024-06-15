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

var ukulele_frets_midi_dictionary := {
	"A_String_0": 69,
	"A_String_1": 70,
	"A_String_2": 71,
	"A_String_3": 72,
	"A_String_4": 73,
	"A_String_5": 74,
	"A_String_6": 75,
	"A_String_7": 76,
	"A_String_8": 77,
	"A_String_9": 78,
	"A_String_10": 79,
	"A_String_11": 80,
	"A_String_12": 81,
	"A_String_13": 82,
	"A_String_14": 83,
	"A_String_15": 84,
	"A_String_16": 85,
	"A_String_17": 86,
	"A_String_18": 87,
	"A_String_19": 88,
	"A_String_20": 89,
	
	"E_String_0": 64,
	"E_String_1": 65,
	"E_String_2": 66,
	"E_String_3": 67,
	"E_String_4": 68,
	"E_String_5": 69,
	"E_String_6": 70,
	"E_String_7": 71,
	"E_String_8": 72,
	"E_String_9": 73,
	"E_String_10": 74,
	"E_String_11": 75,
	"E_String_12": 76,
	"E_String_13": 77,
	"E_String_14": 78,
	"E_String_15": 79,
	"E_String_16": 80,
	"E_String_17": 81,
	"E_String_18": 82,
	"E_String_19": 83,
	"E_String_20": 84,
	
	"C_String_0": 60,
	"C_String_1": 61,
	"C_String_2": 62,
	"C_String_3": 63,
	"C_String_4": 64,
	"C_String_5": 65,
	"C_String_6": 66,
	"C_String_7": 67,
	"C_String_8": 68,
	"C_String_9": 69,
	"C_String_10": 70,
	"C_String_11": 71,
	"C_String_12": 72,
	"C_String_13": 73,
	"C_String_14": 74,
	"C_String_15": 75,
	"C_String_16": 76,
	"C_String_17": 77,
	"C_String_18": 78,
	"C_String_19": 79,
	"C_String_20": 80,
	
	"G_String_0": 67,
	"G_String_1": 68,
	"G_String_2": 69,
	"G_String_3": 70,
	"G_String_4": 71,
	"G_String_5": 72,
	"G_String_6": 73,
	"G_String_7": 74,
	"G_String_8": 75,
	"G_String_9": 76,
	"G_String_10": 77,
	"G_String_11": 78,
	"G_String_12": 79,
	"G_String_13": 80,
	"G_String_14": 81,
	"G_String_15": 82,
	"G_String_16": 83,
	"G_String_17": 84,
	"G_String_18": 85,
	"G_String_19": 86,
	"G_String_20": 87,
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


func get_midi_pitch(from_ukulele_fret: String) -> int:
	# ukulele fret format: "A_String_0"
	var midi_pitch := 0
	midi_pitch = ukulele_frets_midi_dictionary[from_ukulele_fret]
	return midi_pitch


func get_possible_ukulele_frets(from_midi_pitch: int) -> Array[String]:
	var possible_ukulele_frets := [""]
	return possible_ukulele_frets
