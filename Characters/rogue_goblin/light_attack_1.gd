extends RogueGoblinState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	rogue_goblin.sprite.animation_finished.connect(_on_animation_finished)
	rogue_goblin.sprite.frame_changed.connect(_on_frame_changed)
	rogue_goblin.sprite.offset = Vector2(30, 0)
	rogue_goblin.velocity.x = 0
	rogue_goblin.hit_box.previously_hit_hurtboxes = []
	rogue_goblin.sprite.play("light_attack_1")


func _on_animation_finished() -> void:
	if rogue_goblin.sprite.animation == "light_attack_1":
		rogue_goblin.can_attack = false
		rogue_goblin.attack_timer.start(0.5)
		state_machine.transition_to("Idle")


#func hit(area: Area2D) -> void:
	#print('hit ' + str(area) + ' in physics')
	#overlapping_areas.append(area)


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass
	#if rogue_goblin.sprite.frame >= 4:
		#rogue_goblin.hit_box.process_mode = Node.PROCESS_MODE_INHERIT
		#for area in rogue_goblin.hit_box.get_overlapping_areas():
			#if not overlapping_areas.has(area):
				#hit(area)


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass
	## dash
	#if not rogue_goblin.sprite.animation == "light_attack_1":
		#if Input.is_action_just_pressed("dash"):
			#state_machine.transition_to("Dash")
		## block
		#if Input.is_action_pressed("block"):
			#state_machine.transition_to("Block")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	rogue_goblin.sprite.animation_finished.disconnect(_on_animation_finished)
	rogue_goblin.sprite.frame_changed.disconnect(_on_frame_changed)
	rogue_goblin.sprite.offset = Vector2.ZERO
	rogue_goblin.hit_box.process_mode = Node.PROCESS_MODE_DISABLED


func _on_frame_changed() -> void:
	if rogue_goblin.sprite.frame == 4:
		rogue_goblin.hit_box.process_mode = Node.PROCESS_MODE_INHERIT
	if rogue_goblin.sprite.frame == 6:
		rogue_goblin.hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	if rogue_goblin.sprite.frame == 9:
		rogue_goblin.hit_box.previously_hit_hurtboxes = []
		rogue_goblin.hit_box.process_mode = Node.PROCESS_MODE_INHERIT
	if rogue_goblin.sprite.frame == 11:
		rogue_goblin.hit_box.process_mode = Node.PROCESS_MODE_DISABLED
