# idle state
extends FemaleGoblinState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	female_goblin.velocity = Vector2.ZERO
	female_goblin.sprite.offset = Vector2(-15, 0)
	
	female_goblin.sprite.animation_finished.connect(_on_animation_finished)
	female_goblin.sprite.play("hurt", 0.08)
	sprite_flash()
	
func sprite_flash() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(female_goblin.sprite, "modulate:v", 1, 0.2).from(15)
	tween.play()

func _on_animation_finished() -> void:
	pass
	if female_goblin.sprite.animation == "hurt":
		female_goblin.can_attack = false
		female_goblin.attack_timer.start(0.3)
		state_machine.transition_to("Idle")


## Corresponds to the `_process()` callback.
#func update(_delta: float) -> void:
	#pass
#
#
# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass
	#if not female_goblin.velocity.x == 0:
		#state_machine.transition_to("Run")
	#if not female_goblin.velocity.y == 0:
		#state_machine.transition_to("Jump", {"stage": "apex"})


# Receives events from the `_unhandled_input()` callback.
#func handle_input(_event: InputEvent) -> void:
	#controls()


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
#
	## attack
	#if Input.is_action_pressed("light_attack"):
		#state_machine.transition_to("LightAttack1")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	female_goblin.sprite.offset = Vector2.ZERO
	female_goblin.sprite.animation_finished.disconnect(_on_animation_finished)
