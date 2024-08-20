extends Node2D

var is_boss_spawned := false
@onready var boss_packed_scene := preload("res://Characters/boss_goblin/boss_goblin_character_body.tscn")
var screen_size : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, 980*7)
	$FirstBackgroundAudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_boss_spawned == false and $WarriorCharacterBody2D.global_position.x >= 10000:
		$FirstBackgroundAudioStreamPlayer.stop()
		$BackgroundMusic.play()
		print('spawn boss')
		var boss_spawn = boss_packed_scene.instantiate()
		boss_spawn.scale = Vector2(10, 10)
		boss_spawn.global_position = Vector2(11000, -450)
		add_child(boss_spawn)
		is_boss_spawned = true
	#if $EleanoreCharacterBody2D.position.x - $GroundStaticBody2D.position.x > screen_size.x * 1.1:
		#$GroundStaticBody2D.position.x += screen_size.x
	#if $EleanoreCharacterBody2D.position.x - $G roundStaticBody2D.position.x < screen_size.x:
		#$GroundStaticBody2D.position.x -= screen_size.x
