# idle state
extends BossGoblinState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	boss_goblin.sprite.play("idle")
	boss_goblin.sprite.offset = Vector2(0,15)

#
## Corresponds to the `_process()` callback.
#func update(_delta: float) -> void:
	#pass
#
#
# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if not boss_goblin.velocity.x == 0:
		state_machine.transition_to("Run")


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	boss_goblin.sprite.offset = Vector2.ZERO
