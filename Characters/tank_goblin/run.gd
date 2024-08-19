extends TankGoblinState

var direction := 0
# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	tank_goblin.sprite.animation_finished.connect(_on_animation_finished)
	tank_goblin.sprite.offset.x = 0
	tank_goblin.move_detection.body_exited.connect(_on_move_detection_area_exit)
	tank_goblin.sprite.play("run")

func _on_animation_finished() -> void:
	if tank_goblin.animation == "run":
		state_machine.transition_to("Idle")
	
func _on_move_detection_area_exit(body):
	if body.name == "WarriorCharacterBody2D":
		state_machine.transition_to("Idle")
	

# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if tank_goblin.attack_detection.has_overlapping_bodies():
		for body in tank_goblin.attack_detection.get_overlapping_bodies():
			if body.name == "WarriorCharacterBody2D":
				tank_goblin.player_chase = true
				state_machine.transition_to("HeavyAttack")
			else:
				state_machine.transition_to("Idle")
	else:
		if tank_goblin.player_chase:
			if tank_goblin.move_detection.has_overlapping_bodies():
				for body in tank_goblin.move_detection.get_overlapping_bodies():
					if body.name == "WarriorCharacterBody2D":
						tank_goblin.player_chase = true
							
						if body.global_position.x > tank_goblin.global_position.x:
							direction = 1
						else:
							direction = -1
						tank_goblin.sprite.scale.x = direction
						tank_goblin.velocity.x = direction * tank_goblin.SPEED
						
			else:
				state_machine.transition_to("Idle")



## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass



# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	tank_goblin.sprite.animation_finished.disconnect(_on_animation_finished)
	tank_goblin.move_detection.body_exited.disconnect(_on_move_detection_area_exit)
