# idle state
extends WitchState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	witch.sprite.play("idle")
	if Input.get_axis("left", "right") > 0:
		witch.sprite.scale.x = 1
		witch.velocity.x = 1 * witch.SPEED
		state_machine.transition_to("Walk")
	elif Input.get_axis("left", "right") < 0:
		witch.sprite.scale.x = -1
		witch.velocity.x = -1 * witch.SPEED
		state_machine.transition_to("Walk")
	else:
		witch.velocity.x = move_toward(witch.velocity.x, 0, witch.SPEED)


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if not witch.velocity.x == 0:
		state_machine.transition_to("Walk")
	if not witch.velocity.y == 0:
		state_machine.transition_to("Jump", {"stage": "apex"})


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if Input.get_axis("left", "right") > 0:
		witch.sprite.scale.x = 1
		witch.velocity.x = 1 * witch.SPEED
		state_machine.transition_to("Walk")
	elif Input.get_axis("left", "right") < 0:
		witch.sprite.scale.x = -1
		witch.velocity.x = -1 * witch.SPEED
		state_machine.transition_to("Walk")
	else:
		witch.velocity.x = move_toward(witch.velocity.x, 0, witch.SPEED)
	# walk left or right
	#if Input.is_action_pressed("left"):
		#witch.sprite.scale.x = -1
		#witch.velocity.x = -1 * witch.SPEED
		#state_machine.transition_to("Walk")
	#elif Input.is_action_pressed("right"):
		#witch.sprite.scale.x = 1
		#witch.velocity.x = 1 * witch.SPEED
		#state_machine.transition_to("Walk")
	# jump
	if Input.is_action_just_pressed("jump") and witch.is_on_floor():
		state_machine.transition_to("Jump")
	#if event is InputEventKey:
		#if event.keycode == KEY_F:
			#state_machine.transition_to("Attack1") # F
	#if Input.is_action_pressed("fast_cast"): # C
		#state_machine.transition_to("FastCast")
	#if Input.is_action_pressed("strike_cast"): # V
		#state_machine.transition_to("StrikeCast")
	#if Input.is_action_pressed("ice_cast"): # G
		#state_machine.transition_to("IceCast")
	#if Input.is_action_pressed("light_cast"):
		#state_machine.transition_to("LightCast")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass

#func is_movement_key_pressed(event) -> bool:
	#if event.keycode == KEY_W or event.keycode == KEY_A or event.keycode == KEY_S or event.keycode == KEY_D:
		#return true
	#else:
		#return false
