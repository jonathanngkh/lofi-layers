#run state
#essentially, female goblin doesn't run towards anything, it only runs away from player based on a distance passed in from Idle
extends FemaleGoblinState

var start_pos := Vector2.ZERO
var hero_global_position := Vector2.ZERO

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	female_goblin.run_away = true
	female_goblin.sprite.animation_finished.connect(_on_animation_finished)
	female_goblin.sprite.offset.x = -15
	start_pos = female_goblin.global_position
	hero_global_position  = _msg.hero_global_position
	female_goblin.sprite.play("run")


func _on_animation_finished() -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if female_goblin.run_away:
		#female goblin sprite faces right, so if sprite.scale.x is 1, means it's running towards the right and warrior is on left
		if female_goblin.sprite.scale.x > 0:
			if female_goblin.global_position.x >= hero_global_position.x + female_goblin.separation_distance:
				female_goblin.can_attack = true
				state_machine.transition_to("Idle")
		else:
			if female_goblin.global_position.x <= hero_global_position.x - female_goblin.separation_distance:
				female_goblin.can_attack = true
				state_machine.transition_to("Idle")
	pass
	# down
	#if Input.get_axis("up", "down") > 0:
		#female_goblin.sprite.play("run")
		#female_goblin.position.y += 10
	## up
	#elif Input.get_axis("up", "down") < 0:
		#female_goblin.sprite.play("run")
		#female_goblin.position.y += -10



### Receives events from the `_unhandled_input()` callback.
#func handle_input(_event: InputEvent) -> void:
	
	#if Input.get_axis("left", "right") > 0:
		#female_goblin.sprite.scale.x = 1
		#female_goblin.velocity.x = 1 * female_goblin.SPEED
		#female_goblin.sprite.play("run")
	#elif Input.get_axis("left", "right") < 0:
		#female_goblin.sprite.scale.x = -1
		#female_goblin.velocity.x = -1 * female_goblin.SPEED
		#female_goblin.sprite.play("run")
	#elif Input.get_axis("left", "right") == 0 and Input.get_axis("up", "down") == 0:
		#if female_goblin.velocity.x > 0:
			#female_goblin.sprite.scale.x = 1
		#elif female_goblin.velocity.x < 0:
			#female_goblin.sprite.scale.x = -1
		#state_machine.transition_to("Idle")
		
	## jump
	#if Input.is_action_just_pressed("jump") and female_goblin.is_on_floor():
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
	female_goblin.sprite.animation_finished.disconnect(_on_animation_finished)
