extends WitchState


# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	witch.sprite.animation_finished.connect(_on_animation_finished)
	witch.sprite.play("to_walk", 1.6)


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if witch.velocity.x == 0:
		state_machine.transition_to("Idle")
	if witch.velocity.y > 0:
		state_machine.transition_to("Jump")


func _on_animation_finished() -> void:
	if witch.sprite.animation == "to_walk":
		witch.sprite.play("walk")


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	# left or right
	if Input.get_axis("left", "right") > 0:
		if not witch.sprite.animation == "brake":
			witch.sprite.scale.x = 1
			witch.velocity.x = 1 * witch.SPEED
	elif Input.get_action_strength("right") - Input.get_action_strength("left") < 0:
		if not witch.sprite.animation == "brake":
			witch.sprite.scale.x = -1
			witch.velocity.x = -1 * witch.SPEED
	else:
		if not witch.sprite.animation == "brake":
			witch.sprite.play("brake", 1.2)
			#var brake_speed
			var tween = create_tween()
			tween.tween_property(witch, "velocity:x", 0, 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	# dash
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	# jump
	if Input.is_action_just_pressed("jump") and witch.is_on_floor():
		state_machine.transition_to("Jump")
		


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	witch.sprite.animation_finished.disconnect(_on_animation_finished)
