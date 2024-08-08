# idle state
extends WarriorState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	warrior.sprite.play("hurt")
	warrior.sprite.offset = Vector2(7, -25)
	warrior.sprite.animation_finished.connect(_on_animation_finished)


func _on_animation_finished() -> void:
	if warrior.sprite.animation == "hurt":
		state_machine.transition_to("Idle")


## Corresponds to the `_process()` callback.
#func update(_delta: float) -> void:
	#pass
#
#
# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass
	#if not warrior.velocity.x == 0:
		#state_machine.transition_to("Run")
	#if not warrior.velocity.y == 0:
		#state_machine.transition_to("Jump", {"stage": "apex"})


# Receives events from the `_unhandled_input()` callback.
#func handle_input(_event: InputEvent) -> void:
	#controls()


func controls():
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


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	warrior.sprite.offset = Vector2.ZERO
	warrior.sprite.animation_finished.disconnect(_on_animation_finished)
