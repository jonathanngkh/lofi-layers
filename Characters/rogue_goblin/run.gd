extends RogueGoblinState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	rogue_goblin.sprite.animation_finished.connect(_on_animation_finished)
	rogue_goblin.sprite.offset.x = 0
	rogue_goblin.move_detection.body_exited.connect(_on_move_detection_area_exit)
	rogue_goblin.sprite.play("run")

func _on_animation_finished() -> void:
	if rogue_goblin.animation == "run":
		state_machine.transition_to("Idle")
	
func _on_move_detection_area_exit(body):
	if body.name == "WarriorCharacterBody2D":
		state_machine.transition_to("Idle")
	

# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if rogue_goblin.attack_detection.has_overlapping_bodies():
		for body in rogue_goblin.attack_detection.get_overlapping_bodies():
			if rogue_goblin.can_attack:
				if body.name == "WarriorCharacterBody2D":
					rogue_goblin.player_chase = true
					state_machine.transition_to("LightAttack1")
			else:
				state_machine.transition_to("Idle")
	else:
		if rogue_goblin.player_chase:
			if rogue_goblin.move_detection.has_overlapping_bodies():
				for body in rogue_goblin.move_detection.get_overlapping_bodies():
					if body.name == "WarriorCharacterBody2D":
						var goblin_direction := 0
						var global_direction := 0
						rogue_goblin.player_chase = true
							
						if body.global_position.x > rogue_goblin.global_position.x:
							goblin_direction = 1
							global_direction = 1
						else:
							goblin_direction = -1
							global_direction = -1
						rogue_goblin.sprite.scale.x = goblin_direction
						rogue_goblin.velocity.x = global_direction * rogue_goblin.SPEED
						
			else:
				state_machine.transition_to("Idle")
	# down
	#if Input.get_axis("up", "down") > 0:
		#rogue_goblin.sprite.play("run")
		#rogue_goblin.position.y += 10
	## up
	#elif Input.get_axis("up", "down") < 0:
		#rogue_goblin.sprite.play("run")
		#rogue_goblin.position.y += -10



## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass
	#if Input.get_axis("left", "right") > 0:
		#rogue_goblin.sprite.scale.x = 1
		#rogue_goblin.velocity.x = 1 * rogue_goblin.SPEED
		#rogue_goblin.sprite.play("run")
	#elif Input.get_axis("left", "right") < 0:
		#rogue_goblin.sprite.scale.x = -1
		#rogue_goblin.velocity.x = -1 * rogue_goblin.SPEED
		#rogue_goblin.sprite.play("run")
	#elif Input.get_axis("left", "right") == 0 and Input.get_axis("up", "down") == 0:
		#if rogue_goblin.velocity.x > 0:
			#rogue_goblin.sprite.scale.x = 1
		#elif rogue_goblin.velocity.x < 0:
			#rogue_goblin.sprite.scale.x = -1
		#state_machine.transition_to("Idle")
		
	## jump
	#if Input.is_action_just_pressed("jump") and rogue_goblin.is_on_floor():
		#state_machine.transition_to("Jump")
	## dash
	#if Input.is_action_just_pressed("dash"):
		#state_machine.transition_to("Dash")
	## block
	#if Input.is_action_pressed("block"):
		#state_machine.transition_to("Block")
	# attack
	#if Input.is_action_just_pressed("light_attack"):
		#state_machine.transition_to("LightAttack1")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	rogue_goblin.sprite.animation_finished.disconnect(_on_animation_finished)
	rogue_goblin.move_detection.body_exited.disconnect(_on_move_detection_area_exit)
