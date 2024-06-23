extends Control

# on measure incremented, call start measure function
# start measure funtion increases the progress ratio of pathfollow 2d from 0 to 1, duration is amount of time per measure. so beats per bar * seconds per beat. on every 1st, 3rd, 5th and 7th beat, make glow very bright and dim as it travels. experiment with tweens

@onready var conductor: AudioStreamPlayer = $Conductor
var glowing_red := Color(4, 0.1, 0.4)
var glowing_green := Color(0.4, 4.0, 1.3)
var dark_red := Color(0.5, 0, 0)
var dark_green := Color(0, 0.4, 0)
var glow_time : float = 0.1

func _ready():
	#conductor.measure_incremented.connect(_on_conductor_measure_incremented)
	conductor.beat_incremented.connect(_on_conductor_beat_incremented)

func _process(_delta: float) -> void:
	pass


func _on_conductor_beat_incremented():
	if conductor.beat_in_bar % 2 == 0: # use this if bpm and bpb set to 220, 8 as opposed to 110, 4
		bounce()
		return
	if conductor.beat_in_bar == 1:
		glow_red()
	else:
		glow_green()

func glow_red():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Sprite2D/BackGlow, "self_modulate", Color(0, 0 ,0), glow_time).from(glowing_red)
	tween.play()


func glow_green():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Sprite2D/BackGlow, "self_modulate", Color(0, 0, 0), glow_time).from(glowing_green)
	tween.play()


func bounce():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Sprite2D, "position:y", $Sprite2D.position.y + 100, 0.2727).set_ease(Tween.EASE_IN)
	tween.tween_property($Sprite2D, "position:y", $Sprite2D.position.y, 0.2727).set_ease(Tween.EASE_OUT)
	tween.play()
