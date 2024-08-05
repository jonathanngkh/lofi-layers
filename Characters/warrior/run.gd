extends WarriorState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	warrior.sprite.scale.x = 1
	if _msg["direction"] == "left":
		warrior.sprite.play("run_left")
	elif _msg["direction"] == "right":
		warrior.sprite.play("run_right")

	if Input.get_axis("left", "right") > 0:
		warrior.sprite.scale.x = 1
		warrior.velocity.x = 1 * warrior.SPEED
		warrior.sprite.play("run_right")
	elif Input.get_axis("left", "right") < 0:
		warrior.velocity.x = -1 * warrior.SPEED
		warrior.sprite.play("run_left")
	else:
		warrior.velocity.x = move_toward(warrior.velocity.x, 0, warrior.SPEED)


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if warrior.velocity.x == 0:
		state_machine.transition_to("Idle")


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if Input.get_axis("left", "right") > 0:
		warrior.velocity.x = 1 * warrior.SPEED
	elif Input.get_axis("left", "right") < 0:
		warrior.velocity.x = -1 * warrior.SPEED
	else:
		warrior.velocity.x = move_toward(warrior.velocity.x, 0, warrior.SPEED)


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	if warrior.sprite.animation == "run_left":
		warrior.sprite.scale.x = -1
