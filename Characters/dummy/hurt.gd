# idle state
extends DummyState

@onready var enemy_impact_sounds = [
	preload("res://Characters/sfx/sfx_enemy_impact_01 [Draft 2].wav"),
	preload("res://Characters/sfx/sfx_enemy_impact_02 [Draft 2].wav"),
	preload("res://Characters/sfx/sfx_enemy_impact_03 [Draft 2].wav")
]


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	dummy.sprite.animation_finished.connect(_on_animation_finished)
	dummy.sprite.play("hurt")
	$AudioStreamPlayer2D_Impact.stream = enemy_impact_sounds.pick_random()
	$AudioStreamPlayer2D_Impact.play()
	sprite_flash()
	if dummy.random_notes_mode:
		roulette()
	#$Timer.timeout.connect(_rotate_solfege_wheel)

func sprite_flash() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(dummy.sprite, "modulate:v", 1, 0.2).from(15)
	tween.play()

func _on_animation_finished() -> void:
	state_machine.transition_to("Idle")

## Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


func _rotate_solfege_wheel() -> void:
	for solfege_note in dummy.solfege_container.get_children():
		solfege_note.solfege_forward()
	

func roulette() -> void:
	for i in randi_range(1, 7):
		await get_tree().create_timer(0.1).timeout
		_rotate_solfege_wheel()

# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	dummy.sprite.animation_finished.disconnect(_on_animation_finished)
	#$Timer.timeout.disconnect(_rotate_solfege_wheel)
	pass
