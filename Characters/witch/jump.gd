extends WitchState

var can_double_jump := true

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	witch.sprite.animation_finished.connect(_on_animation_finished)
	if _msg:
		if _msg["stage"] == "apex":
			witch.sprite.play("apex")
	else:
		witch.sprite.play("jump")
		witch.velocity.y = witch.JUMP_VELOCITY


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	# left or right
	if Input.is_action_pressed("left"):
		witch.sprite.scale.x = -1
		witch.velocity.x = -1 * witch.SPEED
	elif Input.is_action_pressed("right"):
		witch.sprite.scale.x = 1
		witch.velocity.x = 1 * witch.SPEED
	# stop
	elif Input.is_action_just_released("left") or Input.is_action_just_released("right"):
		witch.velocity.x = move_toward(witch.velocity.x, 0, witch.SPEED)
	# dash
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	# jump
	if Input.is_action_just_pressed("jump"):
		if witch.is_on_floor():
			state_machine.transition_to("Jump")
		else:
			if can_double_jump:
				can_double_jump = false
				witch.sprite.play("double_jump", 2.5)
				witch.velocity.y = witch.JUMP_VELOCITY * 1.3
				witch.sprite.offset.x = 0

# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if witch.velocity.y > 0 and witch.velocity.y < 100:
		witch.sprite.play("apex")
		witch.sprite.offset.x = 40
	if witch.is_on_floor():
		if witch.velocity.x == 0:
			witch.sprite.play("land", 1.2)
		else:
			state_machine.transition_to("Walk")
		

func _on_animation_finished() -> void:
	if witch.sprite.animation == "apex":
		witch.sprite.play("fall")
	elif witch.sprite.animation == "land":
		state_machine.transition_to("Idle")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	witch.sprite.animation_finished.disconnect(_on_animation_finished)
	can_double_jump = true
	#pass
	#witch.velocity.x = move_toward(witch.velocity.x, 0, witch.SPEED)
	#witch.velocity.x = 0
