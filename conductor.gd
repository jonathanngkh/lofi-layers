extends AudioStreamPlayer

# change to 220, and 8 to be able to detect quavers. down beats become 1357
@export var bpm := 110
@export var beats_per_bar := 4 # assumed to be crotchets in 4 4 time
var quavers_per_bar = beats_per_bar * 2
var semiquavers_per_bar = beats_per_bar * 4

@onready var intro: AudioStreamPlayer = $IntroAudioStreamPlayer
@onready var track_1: AudioStreamPlayer = $Track1AudioStreamPlayer
@onready var track_2: AudioStreamPlayer = $Track2AudioStreamPlayer



# Tracking the beat and song position
var song_position_in_seconds = 0.0
var song_position_in_beats = 1 # will always be 1 beat behind what's heard
var sec_per_beat = 60.0 / bpm
var sec_per_quaver = sec_per_beat / 2
var sec_per_semiquaver = sec_per_beat / 4
var last_reported_beat = 0
var beats_before_start = 0
var beat_in_bar = 1
var measure = 1


signal beat_incremented()
signal measure_incremented()
signal measure_minus_one_beat_incremented()
signal beat_in_bar_signal(beat_in_bar)
signal current_measure_signal(measure)


func _ready():
	beat_incremented.connect(_on_beat_incremented)
	sec_per_beat = 60.0 / bpm
	#play_with_beat_offset(6)
	#intro.play()


func _physics_process(_delta):
	if playing:
		song_position_in_seconds = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position_in_seconds -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position_in_seconds / sec_per_beat)) + beats_before_start
		_report_beat()


func _report_beat():
	if last_reported_beat < song_position_in_beats:
		last_reported_beat = song_position_in_beats
		beat_in_bar += 1
		if beat_in_bar > beats_per_bar:
			beat_in_bar = 1
		emit_signal("beat_incremented")
		emit_signal("beat_in_bar_signal", beat_in_bar)


func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()


var time_of_closest_quaver = 0.00
var time_off_quaver = 0.00


func closest_quaver_in_song(time_of_note_played):
	var closest_quaver_in_song = 0
	# when confused, use 60bpm, or 1 sec_per_beat to math)
	closest_quaver_in_song = round(time_of_note_played / sec_per_quaver)
	time_of_closest_quaver = closest_quaver_in_song * sec_per_quaver
	time_off_quaver = abs(time_of_closest_quaver - time_of_note_played)
	closest_quaver_in_song += 1
	#if closest_beat > beats_per_bar: # only if music is meant to loop for beats_in_bar
		#closest_beat = 1
	return Vector2(closest_quaver_in_song, time_off_quaver)

var time_of_closest_beat = 0.00
var time_off_beat = 0.00

func closest_beat_in_song(time_of_note_played):
	var closest_beat_in_song = 0
	# when confused, use 60bpm, or 1 sec_per_beat to math
	closest_beat_in_song = round(time_of_note_played / sec_per_beat)
	time_of_closest_beat = closest_beat_in_song * sec_per_beat
	time_off_beat = abs(time_of_closest_beat - time_of_note_played)
	closest_beat_in_song += 1
	#if closest_beat > beats_per_bar: # only if music is meant to loop for beats_in_bar
		#closest_beat = 1
	return Vector2(closest_beat_in_song, time_off_beat)

func closest_beat_in_bar(time_of_note_played): 
	var closest_beat_in_bar = closest_beat_in_song(time_of_note_played).x
	if int(closest_beat_in_bar) % beats_per_bar == 0:
		closest_beat_in_bar = beats_per_bar
	else:
		closest_beat_in_bar = int(closest_beat_in_bar) % beats_per_bar
	return Vector2(int(closest_beat_in_bar), time_off_beat)
	
func closest_quaver_in_bar(time_of_note_played): #doesnt work
	var closest_quaver_in_bar = closest_quaver_in_song(time_of_note_played).x
	if int(closest_quaver_in_bar) % quavers_per_bar == 0:
		closest_quaver_in_bar = quavers_per_bar
	else:
		closest_quaver_in_bar = int(closest_quaver_in_bar) % quavers_per_bar
	return Vector2(closest_quaver_in_bar, time_off_beat)


func play_from_beat(beat, offset):
	last_reported_beat = beat - 1
	beat_in_bar = beat
	play()
	seek((beat * sec_per_beat) - sec_per_beat)
	beats_before_start = offset
	if beat_in_bar % beats_per_bar == 0:
		beat_in_bar = beats_per_bar 
	else:
		beat_in_bar = beat_in_bar % beats_per_bar

func _on_start_timer_timeout():
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()


func _on_beat_incremented():
	#debug_label4.text = "perfect quaver_played_on: " +  str(closest_beat_in_song(get_song_position_in_seconds()).x)
	#debug_label5.text = "perfect time_off_quaver: " +  str(closest_beat_in_song(get_song_position_in_seconds()).y)
	if beat_in_bar == 1:
		measure += 1
		emit_signal("measure_incremented")
		
	if beat_in_bar == 8:
		emit_signal("measure_minus_one_beat_incremented")
		
	$Label.text = str(beat_in_bar)
	# alternate between 2 tracks on even vs odd measures to retain longtail.
	# beat in bar 4 because intro takes 4 beats in an 8 quaver bar
	if measure == 2:
		if beat_in_bar == 1:
			intro.play()
	
	if measure % 2 == 0:
		if beat_in_bar == 1  and measure >= 3:
			track_1.play()
	else:
		if beat_in_bar == 1  and measure >= 3:
			track_2.play()
