# idle state
extends WarriorState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	$AudioStreamPlayer.play()
	warrior.sprite.offset = Vector2(8, -25)
	warrior.sprite.animation_finished.connect(_on_animation_finished)
	warrior.hurt_box.process_mode = Node.PROCESS_MODE_DISABLED
	warrior.sprite.play("death")
	warrior.velocity.x = 0
	var world = warrior.get_parent()
	world.get_node("BackgroundMusic").stop()
	warrior.game_over_black_screen.visible = true
	warrior.death_sprite_2d.visible = true
	warrior.death_sprite_2d.play("death")
	#get_tree().paused = true
	for node in world.get_children():
		if node.name == "ParallaxBackground":
			node.visible = false
		if not node.is_in_group("player"):
			if not node.name == "ParallaxBackground" and not node.name == "WorldEnvironment" and not node.name == "BackgroundMusic" and not node.name == "AmbientNoise" and not node.name == "FirstBackgroundAudioStreamPlayer" and not node.name == "Timer":
				node.modulate = "000000"
	
	
	
	

func _on_animation_finished() -> void:
	pass
	#var tween: Tween = create_tween()
	#await tween.tween_property(warrior.sprite, "modulate:a", 0, 1).finished
	#warrior.queue_free()


## Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass

#
# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass



# Receives events from the `_unhandled_input()` callback.
#func handle_input(_event: InputEvent) -> void:
	#controls()


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	warrior.sprite.animation_finished.disconnect(_on_animation_finished)
