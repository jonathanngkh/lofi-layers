extends ElementalistState

var earth_projectile_preload := preload("res://utility/earth_projectile.tscn")

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	elementalist.sprite.animation_finished.connect(_on_animation_finished)
	elementalist.sprite.frame_changed.connect(_on_frame_changed)
	elementalist.sprite.play("light_attack", 1.5)
	elementalist.hit_box.previously_hit_hurtboxes = []
	var earth_projectile_instance = earth_projectile_preload.instantiate()
	earth_projectile_instance.scale = elementalist.scale
	earth_projectile_instance.global_position.y = elementalist.global_position.y
	earth_projectile_instance.global_position.x = elementalist.global_position.x + (80 * elementalist.sprite.scale.x)
	earth_projectile_instance.tween.tween_property(earth_projectile_instance, "global_position:y", earth_projectile_instance.global_position.y - 90, 0.2)
	earth_projectile_instance.tween.tween_property(earth_projectile_instance, "global_position:x", earth_projectile_instance.global_position.x + (1200 * elementalist.sprite.scale.x), 0.4)
	elementalist.get_parent().add_child(earth_projectile_instance)


func _on_animation_finished() -> void:
	if elementalist.sprite.animation == "light_attack":
		state_machine.transition_to("Idle")


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	#if elementalist.sprite.frame >= 3:
		#elementalist.hit_box.process_mode = Node.PROCESS_MODE_INHERIT
	var x_vector := Input.get_axis("left", "right")
	var y_vector := Input.get_axis("up", "down")
	var direction_vector := Vector2(x_vector, y_vector)
	elementalist.velocity = direction_vector.normalized() * elementalist.SPEED * 0.5
	elementalist.move_and_slide()


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	# dash
	if not elementalist.sprite.animation == "light_attack":
		if Input.is_action_just_pressed("dash"):
			state_machine.transition_to("Dash")
		# block
		if Input.is_action_pressed("block"):
			state_machine.transition_to("Block")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	elementalist.sprite.animation_finished.disconnect(_on_animation_finished)
	elementalist.sprite.frame_changed.disconnect(_on_frame_changed)
	elementalist.hit_box.process_mode = Node.PROCESS_MODE_DISABLED


func _on_frame_changed() -> void:
	if elementalist.sprite.frame == 0:
		pass
	if elementalist.sprite.frame == 1:
		pass
	if elementalist.sprite.frame == 2:
		pass
	if elementalist.sprite.frame == 3:
		pass
	if elementalist.sprite.frame == 4:
		pass
	if elementalist.sprite.frame == 5:
		pass
