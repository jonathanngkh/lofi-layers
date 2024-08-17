extends Node2D

var screen_size : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, 980*6)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	#if $EleanoreCharacterBody2D.position.x - $GroundStaticBody2D.position.x > screen_size.x * 1.1:
		#$GroundStaticBody2D.position.x += screen_size.x
	#if $EleanoreCharacterBody2D.position.x - $GroundStaticBody2D.position.x < screen_size.x:
		#$GroundStaticBody2D.position.x -= screen_size.xecc
