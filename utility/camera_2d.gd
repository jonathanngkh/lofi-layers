extends Camera2D
@export var randomStrength: float = 10.0 #how violently it shakes
@export var shakeFade: float = 8.0 #how long the shake takes to fade, higher number = fade faster

var start_position
var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = global_position.y
	
func apply_shake():
	shake_strength = randomStrength

func _process(delta):
	global_position.y = start_position
	#if Input.is_action_just_pressed("shake"):
		#apply_shake()
	
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shakeFade * delta)
		offset = randomOffset()

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
