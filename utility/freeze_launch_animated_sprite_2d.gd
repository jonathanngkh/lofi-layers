extends AnimatedSprite2D

var icicle_preload := preload("res://utility/icicle_animated_sprite_2d.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent().get_node("AnimatedSprite2D").scale.x == -1:
		scale.x *= -1
	play("launch", 1.2)
	animation_finished.connect(_on_animation_finished)
	frame_changed.connect(_on_frame_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_finished() -> void:
	queue_free()


func _on_frame_changed() -> void:
	if frame == 3:
		var icicle_spawn = icicle_preload.instantiate()
		icicle_spawn.scale = Vector2(4, 4)
		var icicle_spawn_2 = icicle_preload.instantiate()
		icicle_spawn_2.scale = Vector2(4, 4)
		if get_parent().get_node("AnimatedSprite2D").scale.x == -1:
			icicle_spawn.global_position = get_parent().global_position + Vector2(-300, -90)
			icicle_spawn.scale.x *= -1
			icicle_spawn_2.global_position = get_parent().global_position + Vector2(-150, -90)
			icicle_spawn_2.scale.x *= -1
		else:
			icicle_spawn.global_position = get_parent().global_position + Vector2(300, -90)
			icicle_spawn_2.global_position = get_parent().global_position + Vector2(150, -90)
		get_parent().get_parent().add_child(icicle_spawn)
		get_parent().get_parent().add_child(icicle_spawn_2)
