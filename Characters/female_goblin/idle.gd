# idle state
extends FemaleGoblinState

var direction := 0
# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	female_goblin.sprite.offset.x = -15
	female_goblin.velocity = Vector2.ZERO
	female_goblin.run_away = false
	female_goblin.sprite.play("idle")
#
#
## Corresponds to the `_process()` callback.
#func update(_delta: float) -> void:
	#pass
#
#
# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	#if not already running away
	if not female_goblin.run_away:
		if female_goblin.can_attack:
			if female_goblin.cast_detection.has_overlapping_bodies() and not female_goblin.attack_detection.has_overlapping_bodies():
				for body in female_goblin.cast_detection.get_overlapping_bodies():
					if body.name == "WarriorCharacterBody2D":
						if body.global_position.x > female_goblin.global_position.x:
							direction = 1
						else:
							direction = -1
						female_goblin.sprite.scale.x = direction
						state_machine.transition_to("Charge")
						
			elif female_goblin.attack_detection.has_overlapping_bodies():
				for body in female_goblin.attack_detection.get_overlapping_bodies():
					if body.name == "WarriorCharacterBody2D":
						state_machine.transition_to("LightAttack1")
			
			
						

		#if can't attack, and player is near female_goblin, run away				
		else:
			if female_goblin.move_detection.has_overlapping_bodies():
				for body in female_goblin.move_detection.get_overlapping_bodies():
					if body.name == "WarriorCharacterBody2D":
						
						if body.global_position.x > female_goblin.global_position.x:
							direction = -1
						else:
							direction = 1
						female_goblin.sprite.scale.x = direction
						female_goblin.velocity.x = direction * female_goblin.SPEED
						female_goblin.run_away = true
						state_machine.transition_to("Run", {"hero_global_position":body.global_position})


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	#controls()
	pass


#func controls():
	#if Input.get_axis("left", "right") > 0:
		#female_goblin.sprite.scale.x = 1
		#female_goblin.velocity.x = 1 * female_goblin.SPEED
		#state_machine.transition_to("Run")
	#elif Input.get_axis("left", "right") < 0:
		#female_goblin.sprite.scale.x = -1
		#female_goblin.velocity.x = -1 * female_goblin.SPEED
		#state_machine.transition_to("Run")
	#else:
		#female_goblin.velocity.x = move_toward(female_goblin.velocity.x, 0, female_goblin.SPEED)
	### jump
	##if Input.is_action_pressed("jump") and female_goblin.is_on_floor():
		##state_machine.transition_to("Jump")
	### block
	##if Input.is_action_pressed("block"):
		##state_machine.transition_to("Block")
	## attack
	#if Input.is_action_pressed("light_attack"):
		#state_machine.transition_to("LightAttack1")
	## charge
	#if Input.is_action_pressed("charge"):
		#state_machine.transition_to("Charge")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass
