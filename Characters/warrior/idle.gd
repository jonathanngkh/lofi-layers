# idle state
extends WarriorState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	warrior.sprite.play("idle", 0.7)
	controls()
#
#
## Corresponds to the `_process()` callback.
#func update(_delta: float) -> void:
	#pass
#
#
# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	#if not warrior.velocity.x == 0:
		#state_machine.transition_to("Run")
		# down
	if Input.get_axis("up", "down") > 0:
		state_machine.transition_to("Run")
		warrior.position.y -= 1
	# up
	elif Input.get_axis("up", "down") < 0:
		state_machine.transition_to("Run")
		warrior.position.y += 1
		
	if not warrior.velocity.y == 0:
		state_machine.transition_to("Jump", {"stage": "apex"})


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	controls()
	#if Input.is_action_just_pressed("left_click"):
		#state_machine.transition_to("LightAttack1")
	#if Input.is_action_just_pressed("right_click"):
		#state_machine.transition_to("LightAttack1")


func controls():
	if Input.get_action_strength("reset_scale"):
		warrior.minor_scale_index = 0
	if Input.get_axis("left", "right") > 0:
		warrior.sprite.scale.x = 1
		warrior.velocity.x = 1 * warrior.SPEED
		state_machine.transition_to("Run")
	elif Input.get_axis("left", "right") < 0:
		warrior.sprite.scale.x = -1
		warrior.velocity.x = -1 * warrior.SPEED
		state_machine.transition_to("Run")
	else:
		warrior.velocity.x = move_toward(warrior.velocity.x, 0, warrior.SPEED)
	# jump
	if Input.is_action_pressed("jump") and warrior.is_on_floor():
		state_machine.transition_to("Jump")
	# block
	if Input.is_action_pressed("block"):
		state_machine.transition_to("Block")
	# attack
	if Input.is_action_pressed("light_attack"):
		state_machine.transition_to("LightAttack1")
	
	if Input.is_action_pressed("heavy_attack"):
		state_machine.transition_to("HeavyAttack")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass
