# idle state
extends TankGoblinState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	tank_goblin.sprite.play("hurt")
	tank_goblin.sprite.offset = Vector2(15, 0)
	sprite_flash()
	tank_goblin.sprite.animation_finished.connect(_on_animation_finished)
	if tank_goblin.random_notes_mode:
		roulette()

func _rotate_solfege_wheel() -> void:
	for solfege_note in tank_goblin.solfege_container.get_children():
		solfege_note.solfege_forward()
	

func roulette() -> void:
	for i in randi_range(1, 7):
		await get_tree().create_timer(0.1).timeout
		_rotate_solfege_wheel()
	
func sprite_flash() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(tank_goblin.sprite, "modulate:v", 1, 0.2).from(15)
	tween.play()

func _on_animation_finished() -> void:
	if tank_goblin.sprite.animation == "hurt":
		state_machine.transition_to("Idle")


## Corresponds to the `_process()` callback.
#func update(_delta: float) -> void:
	#pass
#
#
# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass
	#if not tank_goblin.velocity.x == 0:
		#state_machine.transition_to("Run")
	#if not tank_goblin.velocity.y == 0:
		#state_machine.transition_to("Jump", {"stage": "apex"})


# Receives events from the `_unhandled_input()` callback.
#func handle_input(_event: InputEvent) -> void:
	#controls()


func controls():
	if Input.get_axis("left", "right") > 0:
		tank_goblin.sprite.scale.x = 1
		tank_goblin.velocity.x = 1 * tank_goblin.SPEED
		state_machine.transition_to("Run")
	elif Input.get_axis("left", "right") < 0:
		tank_goblin.sprite.scale.x = -1
		tank_goblin.velocity.x = -1 * tank_goblin.SPEED
		state_machine.transition_to("Run")
	else:
		tank_goblin.velocity.x = move_toward(tank_goblin.velocity.x, 0, tank_goblin.SPEED)

	# attack
	if Input.is_action_pressed("light_attack"):
		state_machine.transition_to("LightAttack1")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	tank_goblin.sprite.offset = Vector2.ZERO
	tank_goblin.sprite.animation_finished.disconnect(_on_animation_finished)
