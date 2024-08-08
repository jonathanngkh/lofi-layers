extends WitchState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	witch.sprite.animation_finished.connect(_on_animation_finished)
	witch.sprite.frame_changed.connect(_on_frame_changed)
	witch.sprite.play("light_attack_1", 1.4)
	witch.velocity.x = 0
	witch.hit_box.previously_hit_hurtboxes = []


func _on_animation_finished() -> void:
	if witch.sprite.animation == "light_attack_1":
		state_machine.transition_to("Idle")
	#if witch.sprite.animation == "light_attack_1":
		#witch.sprite.play("light_attack_end", 1.8)
	#elif witch.sprite.animation == "light_attack_end":
		#state_machine.transition_to("Idle")


#func hit(area: Area2D) -> void:
	#print('hit ' + str(area) + ' in physics')
	#overlapping_areas.append(area)


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if witch.sprite.frame >= 3:
		witch.hit_box.process_mode = Node.PROCESS_MODE_INHERIT
		#for area in witch.hit_box.get_overlapping_areas():
			#if not overlapping_areas.has(area):
				#hit(area)


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	# dash
	if not witch.sprite.animation == "light_attack_1":
		if Input.is_action_just_pressed("dash"):
			state_machine.transition_to("Dash")
		# block
		if Input.is_action_pressed("block"):
			state_machine.transition_to("Block")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	witch.sprite.animation_finished.disconnect(_on_animation_finished)
	witch.sprite.frame_changed.disconnect(_on_frame_changed)
	witch.hit_box.process_mode = Node.PROCESS_MODE_DISABLED


func _on_frame_changed() -> void:
	if witch.sprite.frame == 0:
		pass
	if witch.sprite.frame == 1:
		pass
	if witch.sprite.frame == 2:
		pass
	if witch.sprite.frame == 3:
		pass
	if witch.sprite.frame == 4:
		pass
	if witch.sprite.frame == 5:
		pass
