extends WitchState


# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	witch.sprite.play("walk")


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if witch.velocity == Vector2.ZERO:
		state_machine.transition_to("Idle")


# Receives events from the `_unhandled_input()` callback.
func handle_input(event: InputEvent) -> void:
	#if Input.is_action_pressed("left"):
		#witch.sprite.scale.x = -1
		#witch.velocity.x = -1 * witch.SPEED
	#elif Input.is_action_pressed("right"):
		#witch.sprite.scale.x = 1
		#witch.velocity.x = 1 * witch.SPEED
	var direction := Input.get_axis("left", "right")
	if direction:
		if direction == -1:
			witch.sprite.scale.x = -1
		else:
			witch.sprite.scale.x = 1
		witch.velocity.x = direction * witch.SPEED
	else:
		witch.velocity.x = move_toward(witch.velocity.x, 0, witch.SPEED)
# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass
