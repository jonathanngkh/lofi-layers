extends ElementalistState

var initial_jump_velocity := -9.0
var jump_velocity := initial_jump_velocity # per physics frame
var gravity_acceleration := 0.8
var shadow_scale_amount := 0.1

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	if _msg:
		elementalist.shadow.scale.x = _msg["shadow_scale"]
		#jump_velocity = _msg["jump_velocity"]
	elementalist.sprite.animation_finished.connect(_on_animation_finished)
	elementalist.sprite.frame_changed.connect(_on_frame_changed)
	elementalist.sprite.play("air_attack", 1.3)
	
	elementalist.hit_box.previously_hit_hurtboxes = []


func _on_animation_finished() -> void:
	if elementalist.sprite.animation == "air_attack":
		elementalist.sprite.play("fall")


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
		#elementalist.sprite.play("fall")
		elementalist.shadow.scale.x += shadow_scale_amount
	else: # rising
		if elementalist.shadow.scale.x > 0:
			elementalist.shadow.scale.x -= shadow_scale_amount
	
	if elementalist.sprite.frame >= 3:
		elementalist.hit_box.process_mode = Node.PROCESS_MODE_INHERIT
		
	var x_vector := Input.get_axis("left", "right")
	var y_vector := Input.get_axis("up", "down")
	var direction_vector := Vector2(x_vector, y_vector)
	elementalist.velocity = direction_vector.normalized() * elementalist.SPEED * 0.5
	elementalist.move_and_slide()


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	# dash
	if not elementalist.sprite.animation == "air_attack":
		if Input.is_action_just_pressed("dash"):
			state_machine.transition_to("Dash")
		# block
		if Input.is_action_pressed("block"):
			state_machine.transition_to("Block")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	elementalist.shadow.scale.x = 2.292
	jump_velocity = initial_jump_velocity
	elementalist.sprite.animation_finished.disconnect(_on_animation_finished)
	elementalist.sprite.frame_changed.disconnect(_on_frame_changed)
	elementalist.hit_box.process_mode = Node.PROCESS_MODE_DISABLED


func _on_frame_changed() -> void:
	if elementalist.sprite.frame == 0:
		pass
	if elementalist.sprite.frame == 1:
		pass
	if elementalist.sprite.frame == 2:
		pass
	if elementalist.sprite.frame == 3:
		pass
	if elementalist.sprite.frame == 4:
		pass
	if elementalist.sprite.frame == 5:
		pass
