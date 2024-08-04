extends Node2D

var screen_size : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $EleanoreCharacterBody2D.position.x - $GroundStaticBody2D.position.x > screen_size.x * 1.1:
		$GroundStaticBody2D.position.x += screen_size.x
	#if $EleanoreCharacterBody2D.position.x - $GroundStaticBody2D.position.x < screen_size.x:
		#$GroundStaticBody2D.position.x -= screen_size.x
