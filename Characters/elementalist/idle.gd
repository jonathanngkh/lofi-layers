# idle state
extends ElementalistState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	elementalist.sprite.play("idle")

	if Input.is_action_pressed("block"):
		state_machine.transition_to("Block")
	if Input.is_action_pressed("light_attack"):
		state_machine.transition_to("LightAttack1")

# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if elementalist.is_player_controlled:
		if Input.get_axis("left", "right") > 0:
			elementalist.sprite.scale.x = 1
			elementalist.velocity.x = 1 * elementalist.SPEED
			state_machine.transition_to("Walk")
		elif Input.get_axis("left", "right") < 0:
			elementalist.sprite.scale.x = -1
			elementalist.velocity.x = -1 * elementalist.SPEED
			state_machine.transition_to("Walk")
		else:
			elementalist.velocity.x = move_toward(elementalist.velocity.x, 0, elementalist.SPEED)
			
		if Input.get_axis("up", "down") > 0:
			elementalist.velocity.y = 1 * elementalist.SPEED
			state_machine.transition_to("Walk")
		elif Input.get_axis("up", "down") < 0:
			elementalist.velocity.y = -1 * elementalist.SPEED
			state_machine.transition_to("Walk")
		else:
			elementalist.velocity.y = move_toward(elementalist.velocity.y, 0, elementalist.SPEED)
		# block
		if Input.is_action_pressed("block"):
			state_machine.transition_to("Block")
		# jump
		if Input.is_action_just_pressed("jump") and elementalist.is_on_floor():
			state_machine.transition_to("Jump")
		if Input.is_action_pressed("light_attack"):
			state_machine.transition_to("LightAttack1")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass
