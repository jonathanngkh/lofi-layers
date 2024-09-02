extends ElementalistState

var initial_jump_velocity := -18.0
var jump_velocity := initial_jump_velocity # per physics frame
var gravity_acceleration := 1.2

var can_double_jump := true
var allow_air_stop := false

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	elementalist.sprite.animation_finished.connect(_on_animation_finished)
	if _msg:
		if _msg["stage"] == "apex":
			elementalist.sprite.play("fall")
	else:
		elementalist.sprite.play("jump")


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass

# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	elementalist.sprite.offset.y += jump_velocity
	if elementalist.sprite.offset.y < 0: # is in air
		jump_velocity += gravity_acceleration
	else: # is on/below ground
		elementalist.sprite.offset.y = 0
		if elementalist.velocity == Vector2.ZERO:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")
	
	
	if jump_velocity > 0:
		elementalist.sprite.play("fall")
		elementalist.shadow.scale.x += 0.2
	else: # rising
		if elementalist.shadow.scale.x > 0:
			elementalist.shadow.scale.x -= 0.2
	
	if Input.get_axis("left", "right") > 0:
		elementalist.sprite.scale.x = 1
	elif Input.get_axis("left", "right") < 0:
		elementalist.sprite.scale.x = -1
		
	var x_vector := Input.get_axis("left", "right")
	var y_vector := Input.get_axis("up", "down")
	var direction_vector := Vector2(x_vector, y_vector)
	elementalist.velocity = direction_vector.normalized() * elementalist.SPEED
	elementalist.move_and_slide()
		

func _on_animation_finished() -> void:
	if elementalist.sprite.animation == "apex":
		elementalist.sprite.play("fall")
	elif elementalist.sprite.animation == "land":
		state_machine.transition_to("Idle")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	jump_velocity = initial_jump_velocity
	elementalist.sprite.animation_finished.disconnect(_on_animation_finished)
	can_double_jump = true
