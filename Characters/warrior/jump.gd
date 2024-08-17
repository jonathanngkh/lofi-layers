extends WarriorState

var pre_jump_position_y

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	warrior.sprite.animation_finished.connect(_on_animation_finished)
	if _msg:
		if _msg["stage"] == "apex":
			warrior.sprite.play("apex")
	else:
		warrior.sprite.play("jump")
		warrior.velocity.y = warrior.JUMP_VELOCITY

# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if not warrior.sprite.animation == "land":
		if Input.get_axis("left", "right") > 0:
			warrior.sprite.scale.x = 1
			warrior.velocity.x = 1 * warrior.SPEED
		elif Input.get_axis("left", "right") < 0:
			warrior.sprite.scale.x = -1
			warrior.velocity.x = -1 * warrior.SPEED
	else:
		if Input.is_action_pressed("jump"):
			state_machine.transition_to("Jump")
	# dash
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	if Input.is_action_pressed("light_attack"):
		state_machine.transition_to("AirAttack1")

# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if warrior.velocity.y > 0 and warrior.velocity.y < 100:
		warrior.sprite.play("apex")
	if warrior.is_on_floor():
		if warrior.velocity.x == 0:
			if not warrior.sprite.animation == "land":
				warrior.sprite.play("land", 1)
		else:
			state_machine.transition_to("Run")

func _on_animation_finished() -> void:
	if warrior.sprite.animation == "apex":
		warrior.sprite.play("fall")
	elif warrior.sprite.animation == "land":
		state_machine.transition_to("Idle")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	warrior.sprite.animation_finished.disconnect(_on_animation_finished)
