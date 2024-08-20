# idle state
extends FemaleGoblinState
@onready var hurt_sounds = [
	preload("res://Characters/rogue_goblin/sounds/sfx_enemy_roguegoblin_hurt/sfx_enemy_roguegoblin_hurt_01 [Draft 2].wav"),
	preload("res://Characters/rogue_goblin/sounds/sfx_enemy_roguegoblin_hurt/sfx_enemy_roguegoblin_hurt_02 [Draft 2].wav"),
	preload("res://Characters/rogue_goblin/sounds/sfx_enemy_roguegoblin_hurt/sfx_enemy_roguegoblin_hurt_03 [Draft 2].wav"),
	preload("res://Characters/rogue_goblin/sounds/sfx_enemy_roguegoblin_hurt/sfx_enemy_roguegoblin_hurt_04 [Draft 2].wav"),
	preload("res://Characters/rogue_goblin/sounds/sfx_enemy_roguegoblin_hurt/sfx_enemy_roguegoblin_hurt_05 [Draft 2].wav")
]

@onready var enemy_impact_sounds = [
	preload("res://Characters/sfx/sfx_enemy_impact_01 [Draft 2].wav"),
	preload("res://Characters/sfx/sfx_enemy_impact_02 [Draft 2].wav"),
	preload("res://Characters/sfx/sfx_enemy_impact_03 [Draft 2].wav")
]

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	female_goblin.velocity = Vector2.ZERO
	female_goblin.sprite.offset = Vector2(-15, 0)
	$AudioStreamPlayer2D_Hurt.stream = hurt_sounds.pick_random()
	$AudioStreamPlayer2D_Impact.stream = enemy_impact_sounds.pick_random()
	female_goblin.sprite.animation_finished.connect(_on_animation_finished)
	female_goblin.sprite.play("hurt")
	$AudioStreamPlayer2D_Hurt.play()
	$AudioStreamPlayer2D_Impact.play()
	sprite_flash()
	if female_goblin.random_notes_mode:
		roulette()

func _rotate_solfege_wheel() -> void:
	for solfege_note in female_goblin.solfege_container.get_children():
		solfege_note.solfege_forward()
	

func roulette() -> void:
	for i in randi_range(1, 7):
		await get_tree().create_timer(0.1).timeout
		_rotate_solfege_wheel()
	
func sprite_flash() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(female_goblin.sprite, "modulate:v", 1, 0.2).from(15)
	tween.play()

func _on_animation_finished() -> void:
	if female_goblin.sprite.animation == "hurt":
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
