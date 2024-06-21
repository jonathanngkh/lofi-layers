extends Control

# on measure incremented, call start measure function
# start measure funtion increases the progress ratio of pathfollow 2d from 0 to 1, duration is amount of time per measure. so beats per bar * seconds per beat. on every 1st, 3rd, 5th and 7th beat, make glow very bright and dim as it travels. experiment with tweens

@onready var conductor: AudioStreamPlayer = $Conductor


func _ready():
	conductor.measure_incremented.connect(_on_conductor_measure_incremented)
	conductor.beat_incremented.connect(_on_conductor_beat_incremented)


func _on_conductor_measure_incremented():
	start_moving()
	
func _on_conductor_beat_incremented():
	if conductor.beat_in_bar % 2 == 0: # use this if bpm and bpb set to 220, 8 as opposed to 110, 4
		return
	var tween = create_tween()
	if conductor.beat_in_bar == 1:
		# go red
		#tween.tween_property($Path2D/PathFollow2D/Sprite2D, "self_modulate", Color(0.5, 0.5, 0.5), 0.21818).from(Color(1.0, 0.0, 0.0))
		# tween dark from glow green
		tween.tween_property($Path2D/PathFollow2D/Sprite2D, "self_modulate", Color(0.5, 0.5, 0.5), 0.21818).from(Color(4, 0.1, 0.4))
	else:
		# go white/original
		#tween.tween_property($Path2D/PathFollow2D/Sprite2D, "self_modulate", Color(0.5, 0.5, 0.5), 0.5454).from(Color(1.0, 1.0, 1.0))
		tween.tween_property($Path2D/PathFollow2D/Sprite2D, "self_modulate", Color(0.5, 0.5, 0.5), 0.21818).from(Color(0.4, 4.0, 1.3))
	tween.play()
	
func start_moving():
	var tween = create_tween()
	tween.tween_property($Path2D/PathFollow2D, "progress_ratio", 1.0, 2.1818).from(0.0)
	tween.play()
