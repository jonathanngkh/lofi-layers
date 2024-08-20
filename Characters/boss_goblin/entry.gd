# idle state
extends BossGoblinState
var is_falling := true
# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	#$AudioStreamPlayer2.play()
	boss_goblin.sprite.offset = Vector2(0, 0)
	
	#disable hurtbox and hitbox here
	boss_goblin.hurt_box.process_mode = Node.PROCESS_MODE_DISABLED
	boss_goblin.hit_box_1.process_mode = Node.PROCESS_MODE_DISABLED
	boss_goblin.hit_box_2.process_mode = Node.PROCESS_MODE_DISABLED
	
	boss_goblin.sprite.animation_finished.connect(_on_animation_finished)
	boss_goblin.sprite.play("falling")
	boss_goblin.velocity.y = 2000
	
#
#
## Corresponds to the `_process()` callback.
#func update(_delta: float) -> void:
	#pass
#
func _on_animation_finished():
	if boss_goblin.sprite.animation == "entry":
		state_machine.transition_to("Idle")
#
# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if boss_goblin.position.y > 400 and is_falling:
		$AudioStreamPlayer.play()
		boss_goblin.sprite.play("entry")
		is_falling = false
	if boss_goblin.is_on_floor() and boss_goblin.sprite.animation == "entry":
		boss_goblin.velocity.y = 0


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass





# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	boss_goblin.velocity = Vector2.ZERO
	boss_goblin.sprite.animation_finished.disconnect(_on_animation_finished)
	boss_goblin.hurt_box.process_mode = Node.PROCESS_MODE_INHERIT
