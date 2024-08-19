# idle state
extends FemaleGoblinState

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	female_goblin.sprite.offset = Vector2(-15, 0)
	female_goblin.velocity = Vector2.ZERO
	female_goblin.sprite.animation_finished.connect(_on_animation_finished)
	female_goblin.charge_timer.timeout.connect(_on_timer_timeout)
	female_goblin.sprite.play("charge")
	if female_goblin.charge_timer.is_stopped():
		female_goblin.charge_timer.start(0.8)
	
func _on_animation_finished() -> void:
	if female_goblin.sprite.animation == "charge":
		state_machine.transition_to("Idle")


## Corresponds to the `_process()` callback.
#func update(_delta: float) -> void:
	#pass
#
#
# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	get_process_delta_time()
	pass
	#if not female_goblin.velocity.x == 0:
		#state_machine.transition_to("Run")
	#if not female_goblin.velocity.y == 0:
		#state_machine.transition_to("Jump", {"stage": "apex"})


 #Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


func _on_timer_timeout():
	state_machine.transition_to("CastFireball")


	
	
# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	female_goblin.sprite.offset = Vector2.ZERO
	female_goblin.sprite.animation_finished.disconnect(_on_animation_finished)
	female_goblin.charge_timer.timeout.disconnect(_on_timer_timeout)
	female_goblin.charge_timer.stop()
