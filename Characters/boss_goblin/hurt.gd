# idle state
extends BossGoblinState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	boss_goblin.sprite.play("hurt")
	boss_goblin.sprite.offset = Vector2(-15, 0)
	sprite_flash()
	boss_goblin.sprite.animation_finished.connect(_on_animation_finished)
	
func sprite_flash() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(boss_goblin.sprite, "modulate:v", 1, 0.2).from(15)
	tween.play()

func _on_animation_finished() -> void:
	if boss_goblin.sprite.animation == "hurt":
		state_machine.transition_to("Idle")


## Corresponds to the `_process()` callback.
#func update(_delta: float) -> void:
	#pass
#
#
# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass
	#if not boss_goblin.velocity.x == 0:
		#state_machine.transition_to("Run")
	#if not boss_goblin.velocity.y == 0:
		#state_machine.transition_to("Jump", {"stage": "apex"})


# Receives events from the `_unhandled_input()` callback.
#func handle_input(_event: InputEvent) -> void:
	#controls()


func controls():
	if Input.get_axis("left", "right") > 0:
		boss_goblin.sprite.scale.x = 1
		boss_goblin.velocity.x = 1 * boss_goblin.SPEED
		state_machine.transition_to("Run")
	elif Input.get_axis("left", "right") < 0:
		boss_goblin.sprite.scale.x = -1
		boss_goblin.velocity.x = -1 * boss_goblin.SPEED
		state_machine.transition_to("Run")
	else:
		boss_goblin.velocity.x = move_toward(boss_goblin.velocity.x, 0, boss_goblin.SPEED)

	# attack
	if Input.is_action_pressed("light_attack"):
		state_machine.transition_to("LightAttack1")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	boss_goblin.sprite.offset = Vector2.ZERO
	boss_goblin.sprite.animation_finished.disconnect(_on_animation_finished)
