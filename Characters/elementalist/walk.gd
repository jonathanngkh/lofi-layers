extends ElementalistState

# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	elementalist.sprite.offset.x = 40
	elementalist.sprite.animation_finished.connect(_on_animation_finished)
	elementalist.sprite.play("to_walk", 1.6)
	if Input.get_axis("left", "right") == 0:
		if not elementalist.velocity.x == 0:
			elementalist.sprite.play("brake", 1.8)
			var tween = create_tween()
			tween.tween_property(elementalist, "velocity:x", 0, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
			tween.play()

# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	#if elementalist.velocity.x == 0:
		#state_machine.transition_to("Idle")
	if not elementalist.velocity.y == 0:
		state_machine.transition_to("Jump", {"stage": "apex"})


func _on_animation_finished() -> void:
	if elementalist.sprite.animation == "to_walk":
		elementalist.sprite.play("walk")
	if elementalist.sprite.animation == "brake":
		state_machine.transition_to("Idle")


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	controls()


func controls() -> void:
		# left or right
	if not elementalist.sprite.animation == "brake":
		if Input.get_axis("left", "right") > 0:
			elementalist.sprite.scale.x = 1
			elementalist.velocity.x = 1 * elementalist.SPEED
			elementalist.sprite.play("walk")
		elif Input.get_axis("left", "right") < 0:
			elementalist.sprite.scale.x = -1
			elementalist.velocity.x = -1 * elementalist.SPEED
			elementalist.sprite.play("walk")
		elif Input.get_axis("left", "right") == 0:
			if not elementalist.velocity.x == 0:
				elementalist.sprite.play("brake", 1.8)
				var tween = create_tween()
				tween.tween_property(elementalist, "velocity:x", 0, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
				tween.play()
	# dash
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	# jump
	if Input.is_action_just_pressed("jump") and elementalist.is_on_floor():
		state_machine.transition_to("Jump")
	# block
	if Input.is_action_pressed("block"):
		state_machine.transition_to("Block")
	if Input.is_action_pressed("light_attack"):
		state_machine.transition_to("LightAttack1")

# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	elementalist.sprite.animation_finished.disconnect(_on_animation_finished)
