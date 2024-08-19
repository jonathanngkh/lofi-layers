# idle state
extends TankGoblinState
var direction := 0
# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	tank_goblin.player_chase = false
	tank_goblin.sprite.offset.x = 15
	tank_goblin.velocity = Vector2.ZERO
	tank_goblin.sprite.play("idle")
#
#
## Corresponds to the `_process()` callback.
#func update(_delta: float) -> void:
	#pass
#
#
# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if not tank_goblin.is_resting:
		if tank_goblin.attack_detection.has_overlapping_bodies():
			for body in tank_goblin.attack_detection.get_overlapping_bodies():
				if body.name == "WarriorCharacterBody2D":
						tank_goblin.player_chase = true
						state_machine.transition_to("HeavyAttack")
					
		else:
			if tank_goblin.move_detection.has_overlapping_bodies() and not tank_goblin.player_chase:
				for body in tank_goblin.move_detection.get_overlapping_bodies():
					if body.name == "WarriorCharacterBody2D":
						tank_goblin.player_chase = true
							
						if body.global_position.x > tank_goblin.global_position.x:
							direction = 1
						else:
							direction = -1
						tank_goblin.sprite.scale.x = direction
						tank_goblin.velocity.x = direction * tank_goblin.SPEED
						state_machine.transition_to("Run")


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass

# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	pass
