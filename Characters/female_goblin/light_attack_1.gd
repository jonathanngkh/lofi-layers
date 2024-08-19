extends FemaleGoblinState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	female_goblin.sprite.animation_finished.connect(_on_animation_finished)
	female_goblin.sprite.frame_changed.connect(_on_frame_changed)
	female_goblin.hit_box.damage = female_goblin.damage
	female_goblin.sprite.offset = Vector2(-15, 0)
	female_goblin.velocity = Vector2.ZERO
	female_goblin.hit_box.previously_hit_hurtboxes = []
	female_goblin.sprite.play("light_attack_1")


func _on_animation_finished() -> void:
	if female_goblin.sprite.animation == "light_attack_1":
		female_goblin.can_attack = false
		female_goblin.attack_timer.start(female_goblin.attack_delay)
		state_machine.transition_to("Idle")


#func hit(area: Area2D) -> void:
	#print('hit ' + str(area) + ' in physics')
	#overlapping_areas.append(area)


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass
	#if female_goblin.sprite.frame >= 4:
		#female_goblin.hit_box.process_mode = Node.PROCESS_MODE_INHERIT
		#for area in female_goblin.hit_box.get_overlapping_areas():
			#if not overlapping_areas.has(area):
				#hit(area)


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass
	## dash
	#if not female_goblin.sprite.animation == "light_attack_1":
		#if Input.is_action_just_pressed("dash"):
			#state_machine.transition_to("Dash")
		## block
		#if Input.is_action_pressed("block"):
			#state_machine.transition_to("Block")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	female_goblin.sprite.animation_finished.disconnect(_on_animation_finished)
	female_goblin.sprite.frame_changed.disconnect(_on_frame_changed)
	female_goblin.sprite.offset = Vector2.ZERO
	female_goblin.hit_box.process_mode = Node.PROCESS_MODE_DISABLED


func _on_frame_changed() -> void:
	if female_goblin.sprite.frame == 6:
		female_goblin.hit_box.process_mode = Node.PROCESS_MODE_INHERIT
	if female_goblin.sprite.frame == 9:
		female_goblin.hit_box.process_mode = Node.PROCESS_MODE_DISABLED
