extends Sprite2D

@export var debug_mode := false

var glow_time : float = Conductor.sec_per_beat
var bounce_height : float = 50.0

var glowing_red := Color(4, 0.1, 0.4)
var glowing_green := Color(0.4, 4.0, 1.3)
var glowing_white := Color(3.5, 3.5, 3.5)
var dark_red := Color(0.5, 0, 0)
var dark_green := Color(0, 0.4, 0)


func _ready():
	#conductor.measure_incremented.connect(_on_conductor_measure_incremented)
	#Conductor.beat_incremented.connect(_on_conductor_beat_incremented)
	if debug_mode:
		Conductor.start_conducting()
	Conductor.downbeat_incremented.connect(bounce)

func _process(_delta: float) -> void:
	pass


#func _on_conductor_beat_incremented():
	## use this if bpm and bpb set to 220, 8 as opposed to 110, 4
	#if Conductor.beat_in_bar % 2 == 0: # every even beat 0 2 4 6 8
		##bounce()
		#pass
	#else: # every odd beat 1 3 5 7
		#bounce()


func move_horizontally_to(next_location_x: float) -> void:
	var tween = create_tween()
	tween.tween_property(self, "position:x", next_location_x, Conductor.sec_per_beat * 2)
	tween.play()


func glow_red():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property($BackGlow, "self_modulate", Color(0, 0 ,0), glow_time).from(glowing_red)
	tween.play()


func glow_green():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property($BackGlow, "self_modulate", Color(0, 0, 0), glow_time).from(glowing_green)
	tween.play()


func glow_white():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property($BackGlow, "self_modulate", Color(0, 0, 0), glow_time).from(glowing_white)
	tween.play()


func bounce():
	glow_white()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	#tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "position:y", position.y - bounce_height, Conductor.sec_per_beat - 0.01).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", position.y, Conductor.sec_per_beat - 0.01).set_ease(Tween.EASE_IN)
	tween.play()
