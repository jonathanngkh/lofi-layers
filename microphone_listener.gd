extends Node

#var spectrum_analyzer = AudioServer.get_bus_effect_instance(1, 1)
@onready var timer: Timer = $Timer

var pitch_frequency_dictionary = {
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

var tolerance: float = 1.0

var pitch_frequency_range_dictionary = {}

func get_pitch_freq_range_dict() -> Dictionary:
	for pitch in pitch_frequency_dictionary:
		pitch_frequency_range_dictionary[pitch] = Vector2(pitch_frequency_dictionary[pitch] - tolerance, pitch_frequency_dictionary[pitch] + tolerance)
	return pitch_frequency_range_dictionary

var aubio_output = []
var thread: Thread

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureButton.connect("pressed", button_reaction)
	$TextureButton2.connect("pressed", button_reaction2)
	thread = Thread.new()
	thread.start(start_aubio_listener)
	#OS.execute("pip3", ["install", "pyaudio"], output, true)
	#OS.execute("pip3", ["install", "numpy"], output, true)
	#OS.execute("pip3", ["install", "aubio"], output, true)
	#OS.execute("python3", ["demo_pyaudio.py"], aubio_output, true)
	#$Label.text = output[0]
	get_pitch_freq_range_dict()
	timer.timeout.connect(_on_timer_timeout)
	#print("Available Input Devices: ", AudioServer.get_input_device_list())
	#for input_device in AudioServer.get_input_device_list():
		#if input_device == "Samson C01U Pro Mic (224)":
			#AudioServer.input_device = input_device
		#if input_device == "MacBook Air Microphone (131)":
			#AudioServer.input_device = input_device
		#if input_device == "External Microphone (224)": # razer earphones
			#AudioServer.input_device = input_device
	#print("Connected Input Device: ", AudioServer.input_device)
	
	#print("Available Output Devices: ", AudioServer.get_output_device_list())
	#for output_device in AudioServer.get_output_device_list():
		#if output_device == "External Headphones (217)":
			#AudioServer.output_device = output_device
	#print("Connected Output Device: ", AudioServer.output_device)

func button_reaction() -> void:
	thread.wait_to_finish()
	print(aubio_output)
	for line in aubio_output:
		$Label.text = line.left(-24)

func button_reaction2() -> void:
	thread.start(start_aubio_listener)


func start_aubio_listener() -> void:
	OS.execute("python3", ["demo_pyaudio.py", "recording.wav"], aubio_output, true)
	#OS.execute("python3", ["hello_world.py"], aubio_output, true)
	#OS.set_environment("PYTHONBUFFERD", "1")
	#OS.execute("python3", ["demo_pyaudio.py"], aubio_output, true, true)
	

func _on_timer_timeout() -> void:
	thread.start(start_aubio_listener)
	#timer.start()
	#print(spectrum_analyzer.get_magnitude_for_frequency_range(259, 262, 1)) # C4 60
	#print(spectrum_analyzer.get_magnitude_for_frequency_range(129, 131, 1)) # C3 48
	#print(spectrum_analyzer.get_magnitude_for_frequency_range(522, 524, 1)) # C5 72
	#pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if thread.is_alive():
		thread.wait_to_finish()
	for line in aubio_output:
		$Label.text = line
	#print(aubio_output)
	pass
	#$Label.text = str(spectrum_analyzer.get_magnitude_for_frequency_range(440.0 - 1.0, 440.0 + 1.0, 1).length())
	#var strongest_range = Vector2.ZERO
	#for test_range in pitch_frequency_range_dictionary.values():
		#if spectrum_analyzer.get_magnitude_for_frequency_range(test_range.x - tolerance, test_range.y + tolerance).length() > strongest_range.length():
			#strongest_range = test_range
	#$Label.text = str(strongest_range)
	#for pitch in pitch_frequency_range_dictionary:
		#if spectrum_analyzer.get_magnitude_for_frequency_range(pitch_frequency_range_dictionary[pitch].x, pitch_frequency_range_dictionary[pitch].y).x > 0.1:
			#$Label.text = str(MusicTheoryDB.get_note_name(pitch), MusicTheoryDB.get_note_octave(pitch), " ", pitch, " was played. Frequency range: ", pitch_frequency_range_dictionary[pitch])
	#if spectrum_analyzer.get_magnitude_for_frequency_range(522, 524, 1).x > 0.2:
		#print('C5 was played')
	#if spectrum_analyzer.get_magnitude_for_frequency_range(259, 262, 1).x > 0.2:
		#print('C4 was played')
	#if spectrum_analyzer.get_magnitude_for_frequency_range(129, 131, 1).x > 0.2:
		#print('C3 was played')
