# idle state
extends WarriorState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	warrior.velocity.x = 0
	warrior.sprite.play("block_start")
	warrior.sprite.animation_finished.connect(_on_animation_finished)
#
#
## Corresponds to the `_process()` callback.
#func update(_delta: float) -> void:
	#pass
#
#
# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass
	#if Input.is_action_pressed("block"):
		#warrior.velocity.x = 0
	#if not warrior.velocity.x == 0:
		#state_machine.transition_to("Run")
	#if not warrior.velocity.y == 0:
		#state_machine.transition_to("Jump", {"stage": "apex"})


func _on_animation_finished() -> void:
	if warrior.sprite.animation == "block_start":
		warrior.sprite.play("block")
	if warrior.sprite.animation == "block_end":
		state_machine.transition_to("Idle")

# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if Input.get_axis("left", "right") > 0:
		warrior.sprite.scale.x = 1
	elif Input.get_axis("left", "right") < 0:
		warrior.sprite.scale.x = -1
	else:
		warrior.velocity.x = move_toward(warrior.velocity.x, 0, warrior.SPEED)
	# jump
	if Input.is_action_just_pressed("jump") and warrior.is_on_floor():
		state_machine.transition_to("Jump")
	# keep blocking
	#if Input.is_action_just_pressed("block"):
		#warrior.sprite.play("block")
	if Input.is_action_just_released("block"):
		warrior.sprite.play("block_end")



# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	warrior.sprite.animation_finished.disconnect(_on_animation_finished)
