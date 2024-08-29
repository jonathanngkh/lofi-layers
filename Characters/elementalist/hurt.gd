# idle state
extends ElementalistState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	elementalist.sprite.offset.x = 40
	elementalist.sprite.play("hurt")
	sprite_flash()
	elementalist.sprite.animation_finished.connect(_on_animation_finished)


func sprite_flash() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(elementalist.sprite, "modulate:v", 1, 0.2).from(15)
	tween.play()


func _on_animation_finished() -> void:
	if elementalist.sprite.animation == "hurt":
		state_machine.transition_to("Idle")


## Corresponds to the `_process()` callback.
#func update(_delta: float) -> void:
	#pass
#
#
# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass
	#if not elementalist.velocity.x == 0:
		#state_machine.transition_to("Run")
	#if not elementalist.velocity.y == 0:
		#state_machine.transition_to("Jump", {"stage": "apex"})


# Receives events from the `_unhandled_input()` callback.
#func handle_input(_event: InputEvent) -> void:
	#controls()


func controls():
	if Input.get_axis("left", "right") > 0:
		elementalist.sprite.scale.x = 1
		elementalist.velocity.x = 1 * elementalist.SPEED
		state_machine.transition_to("Run")
	elif Input.get_axis("left", "right") < 0:
		elementalist.sprite.scale.x = -1
		elementalist.velocity.x = -1 * elementalist.SPEED
		state_machine.transition_to("Run")
	else:
		elementalist.velocity.x = move_toward(elementalist.velocity.x, 0, elementalist.SPEED)
	# jump
	if Input.is_action_pressed("jump") and elementalist.is_on_floor():
		state_machine.transition_to("Jump")
	# block
	if Input.is_action_pressed("block"):
		state_machine.transition_to("Block")
	# attack
	if Input.is_action_pressed("light_attack"):
		state_machine.transition_to("LightAttack1")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	elementalist.sprite.animation_finished.disconnect(_on_animation_finished)
