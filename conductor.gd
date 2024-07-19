extends AudioStreamPlayer

# change to 220, and 8 to be able to detect quavers. down beats become 1,3,5,7
@export var bpm: float = 220.0
@export var beats_per_bar: int = 8 # assumed to be crotchets in 4 4 time
@export var autostart := false

@onready var intro: AudioStreamPlayer = $IntroAudioStreamPlayer
@onready var track_1: AudioStreamPlayer = $Track1AudioStreamPlayer
@onready var track_2: AudioStreamPlayer = $Track2AudioStreamPlayer

# Tracking the beat and song position
var song_position_in_seconds = 0.0
var song_position_in_beats = 1 # will always be 1 beat behind what's heard
var sec_per_beat: float = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var beat_in_bar = 1
var measure = 1

signal beat_incremented()
signal downbeat_incremented()
signal upbeat_incremented()
signal measure_incremented()
signal measure_minus_one_beat_incremented()
signal beat_in_bar_signal(beat_in_bar)
signal current_measure_signal(measure)


func _ready() -> void:
	$StartTimer.timeout.connect(_on_start_timer_timeout)
	beat_incremented.connect(_on_beat_incremented)
	sec_per_beat = 60.0 / bpm
	if autostart:
		start_conducting()


func start_conducting() -> void:
	self.play()
	intro.play()


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
		beat_incremented.emit()
		beat_in_bar_signal.emit(beat_in_bar)


func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()


var time_of_closest_beat = 0.00
var time_off_beat = 0.00

func closest_beat_in_song(time_of_note_played: float):
	var closest_beat_in_song = 0
	# when confused, use 60bpm, or 1 sec_per_beat to math
	closest_beat_in_song = round(time_of_note_played / sec_per_beat)
	time_of_closest_beat = closest_beat_in_song * sec_per_beat
	
	time_off_beat = abs(time_of_closest_beat - time_of_note_played)
	closest_beat_in_song += 1
	#if closest_beat > beats_per_bar: # only if music is meant to loop for beats_in_bar
		#closest_beat = 1
	var punctuality
	if time_of_note_played > time_of_closest_beat:
		punctuality = "late"
	else:
		punctuality = "early"
	return [int(closest_beat_in_song), time_off_beat, punctuality]


func closest_beat_in_bar(time_of_note_played: float): 
	var closest_beat_in_bar = closest_beat_in_song(time_of_note_played)[0]
	if int(closest_beat_in_bar) % beats_per_bar == 0:
		closest_beat_in_bar = beats_per_bar
	else:
		closest_beat_in_bar = int(closest_beat_in_bar) % beats_per_bar
		
	return [int(closest_beat_in_bar), time_off_beat]


func get_time_off_closest_beat_in_bar(time_of_note_played: float) -> float:
	return closest_beat_in_bar(time_of_note_played)[1]


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
	if beat_in_bar == 1:
		measure += 1
		measure_incremented.emit()
		
	if beat_in_bar == 8:
		measure_minus_one_beat_incremented.emit()
		
	if not beat_in_bar % 2 == 0: # odd beats 1357
		downbeat_incremented.emit()
	else: # even beats 2468
		upbeat_incremented.emit()
	
	if measure >= 2:
		if beat_in_bar == 1:
			$ClosedHitAudioStreamPlayer.play()
			$OpenHitAudioStreamPlayer2.play()
		if beat_in_bar == 2:
			pass
		if beat_in_bar == 3:
			$OpenHitAudioStreamPlayer.play()
		if beat_in_bar == 4:
			pass
		if beat_in_bar == 5:
			$OpenHitAudioStreamPlayer2.play()
		if beat_in_bar == 6:
			pass
		if beat_in_bar == 7:
			$OpenHitAudioStreamPlayer.play()
		if beat_in_bar == 8:
			pass
		
		
	$Label.text = str(beat_in_bar)
	# alternate between 2 tracks on even vs odd measures to retain longtail.
	# beat in bar 4 because intro takes 4 beats in an 8 quaver bar
	
	if measure % 2 == 0 and measure >= 2:
		if beat_in_bar == 1:
			track_1.play()
	else:
		if beat_in_bar == 1:
			track_2.play()


func change_bpm(new_bpm) -> void:
	bpm = float(new_bpm)
	sec_per_beat = 60.0 / bpm
	song_position_in_seconds = 0.0
	song_position_in_beats = 1 # will always be 1 beat behind what's heard
	last_reported_beat = 0
	beat_in_bar = 1
	measure = 1
	self.play(0.0)
	intro.play(0.0)
