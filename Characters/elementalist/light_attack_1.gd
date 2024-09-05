extends ElementalistState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	elementalist.sprite.animation_finished.connect(_on_animation_finished)
	elementalist.sprite.frame_changed.connect(_on_frame_changed)
	elementalist.sprite.play("light_attack", 1.4)
	elementalist.hit_box.previously_hit_hurtboxes = []


func _on_animation_finished() -> void:
	if elementalist.sprite.animation == "light_attack":
		state_machine.transition_to("Idle")


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if elementalist.sprite.frame >= 3:
		elementalist.hit_box.process_mode = Node.PROCESS_MODE_INHERIT


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	# dash
	if not elementalist.sprite.animation == "light_attack":
		if Input.is_action_just_pressed("dash"):
			state_machine.transition_to("Dash")
		# block
		if Input.is_action_pressed("block"):
			state_machine.transition_to("Block")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
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
