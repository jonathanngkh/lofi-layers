# idle state
extends RogueGoblinState

	

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	rogue_goblin.player_chase = false
	rogue_goblin.sprite.offset.x = 30
	rogue_goblin.velocity = Vector2.ZERO
	rogue_goblin.sprite.play("idle")

## Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass
#
#
# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if rogue_goblin.can_attack:
		if rogue_goblin.attack_detection.has_overlapping_bodies():
			for body in rogue_goblin.attack_detection.get_overlapping_bodies():
				if body.name == "WarriorCharacterBody2D":
					
						rogue_goblin.player_chase = true
						state_machine.transition_to("LightAttack1")
					
					
					
		else:
			if rogue_goblin.move_detection.has_overlapping_bodies() and not rogue_goblin.player_chase:
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
						state_machine.transition_to("Run")
				
				
				
	#if rogue_goblin.is_played_controlled:
		#if not rogue_goblin.velocity.x == 0:
			#state_machine.transition_to("Run")
			## down
		#if Input.get_axis("up", "down") > 0:
			#state_machine.transition_to("Run")
			#rogue_goblin.position.y -= 1
		## up
		#elif Input.get_axis("up", "down") < 0:
			#state_machine.transition_to("Run")
			#rogue_goblin.position.y += 1
			#
		#if not rogue_goblin.velocity.y == 0:
			#state_machine.transition_to("Jump", {"stage": "apex"})


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	#controls()
	pass


#func controls():
	#if Input.get_axis("left", "right") > 0:
		#rogue_goblin.sprite.scale.x = 1
		#rogue_goblin.velocity.x = 1 * rogue_goblin.SPEED
		#state_machine.transition_to("Run")
	#elif Input.get_axis("left", "right") < 0:
		#rogue_goblin.sprite.scale.x = -1
		#rogue_goblin.velocity.x = -1 * rogue_goblin.SPEED
		#state_machine.transition_to("Run")
	#else:
		#rogue_goblin.velocity.x = move_toward(rogue_goblin.velocity.x, 0, rogue_goblin.SPEED)
	## jump
	#if Input.is_action_pressed("jump") and rogue_goblin.is_on_floor():
		#state_machine.transition_to("Jump")
	## block
	#if Input.is_action_pressed("block"):
		#state_machine.transition_to("Block")
	# attack
	#if Input.is_action_pressed("light_attack"):
		#state_machine.transition_to("LightAttack1")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass
