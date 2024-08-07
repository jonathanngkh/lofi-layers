extends WarriorState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	warrior.sprite.animation_finished.connect(_on_animation_finished)
	warrior.sprite.play("run_start", 1.6)

	if Input.get_axis("left", "right") == 0:
		warrior.sprite.play("run_break", 1.5)
		var tween = create_tween()
		tween.tween_property(warrior, "velocity:x", 0, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)


func _on_animation_finished() -> void:
	if warrior.sprite.animation == "run_start":
		warrior.sprite.play("run")


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if warrior.velocity.x == 0:
		state_machine.transition_to("Idle")


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if not warrior.sprite.animation == "run_break":
		if Input.get_axis("left", "right") > 0:
			warrior.sprite.scale.x = 1
			warrior.velocity.x = 1 * warrior.SPEED
			warrior.sprite.play("run")
		elif Input.get_axis("left", "right") < 0:
			warrior.sprite.scale.x = -1
			warrior.velocity.x = -1 * warrior.SPEED
			warrior.sprite.play("run")
		else:
			if warrior.velocity.x > 0:
				warrior.sprite.scale.x = 1
			elif warrior.velocity.x < 0:
				warrior.sprite.scale.x = -1
			warrior.sprite.play("run_break", 1.5)
			var tween = create_tween()
			tween.tween_property(warrior, "velocity:x", 0, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	# jump
	if Input.is_action_just_pressed("jump") and warrior.is_on_floor():
		state_machine.transition_to("Jump")
	# dash
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	# block
	if Input.is_action_pressed("block"):
		state_machine.transition_to("Block")
	# attack
	if Input.is_action_just_pressed("light_attack"):
		state_machine.transition_to("LightAttack1")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	warrior.sprite.animation_finished.disconnect(_on_animation_finished)
