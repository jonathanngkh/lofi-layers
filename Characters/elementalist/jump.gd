extends ElementalistState

var can_double_jump := true
var allow_air_stop := false
var position_y_before_jump

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	position_y_before_jump = elementalist.shadow.global_position.y
	elementalist.sprite.animation_finished.connect(_on_animation_finished)
	if _msg:
		if _msg["stage"] == "apex":
			elementalist.sprite.play("fall")
	else:
		elementalist.sprite.play("jump")
	
		#elementalist.velocity.y = elementalist.JUMP_VELOCITY


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if Input.get_axis("left", "right") > 0:
		elementalist.sprite.scale.x = 1
		elementalist.velocity.x = 1 * elementalist.SPEED
	elif Input.get_axis("left", "right") < 0:
		elementalist.sprite.scale.x = -1
		elementalist.velocity.x = -1 * elementalist.SPEED
	
	#else:
		#if allow_air_stop:
			#elementalist.velocity.x = move_toward(elementalist.velocity.x, 0, elementalist.SPEED)
	# dash
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	# jump
	if Input.is_action_just_pressed("jump"):
		if elementalist.is_on_floor():
			state_machine.transition_to("Jump")
		else:
			if can_double_jump:
				can_double_jump = false
				elementalist.sprite.offset.x = 0
				elementalist.sprite.play("double_jump", 2.2)
				elementalist.velocity.y = elementalist.JUMP_VELOCITY * 1.4
	elementalist.move_and_slide()

# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	elementalist.shadow.global_position.y = position_y_before_jump
	if elementalist.sprite.animation == "block_end":
		elementalist.sprite.stop()
		elementalist.sprite.play("jump")


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	elementalist.sprite.offset.y += -10
	if elementalist.velocity.y > 0 and elementalist.velocity.y < 100:
		elementalist.sprite.play("fall")
	if elementalist.is_on_floor():
			state_machine.transition_to("Walk")
		

func _on_animation_finished() -> void:
	if elementalist.sprite.animation == "apex":
		elementalist.sprite.play("fall")
	elif elementalist.sprite.animation == "land":
		state_machine.transition_to("Idle")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	elementalist.sprite.animation_finished.disconnect(_on_animation_finished)
	can_double_jump = true
	#elementalist.shadow.global_position.y = position_y_before_jump
	elementalist.shadow.position.y = 26
