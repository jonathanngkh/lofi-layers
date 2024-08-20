# death state
extends RogueGoblinState

@onready var death_sounds = [
	preload("res://Characters/rogue_goblin/sounds/sfx_enemy_roguegoblin_death/sfx_enemy_roguegoblin_death [Draft 2].wav"),
]

@onready var enemy_impact_sounds = [
	preload("res://Characters/sfx/sfx_enemy_impact_01 [Draft 2].wav"),
	preload("res://Characters/sfx/sfx_enemy_impact_02 [Draft 2].wav"),
	preload("res://Characters/sfx/sfx_enemy_impact_03 [Draft 2].wav")
]

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	rogue_goblin.sprite.offset = Vector2(0, 5)
	rogue_goblin.velocity = Vector2.ZERO
	
	rogue_goblin.sprite.animation_finished.connect(_on_animation_finished)
	rogue_goblin.hurt_box.process_mode = Node.PROCESS_MODE_DISABLED
	$AudioStreamPlayer2D_Impact.stream = enemy_impact_sounds.pick_random()
	$AudioStreamPlayer2D_Death.stream = death_sounds[0]
	rogue_goblin.sprite.play("death")
	$AudioStreamPlayer2D_Impact.play()
	$AudioStreamPlayer2D_Death.play()
	$AudioStreamPlayer.play()
	

func _on_animation_finished() -> void:
	var tween: Tween = create_tween()
	await tween.tween_property(rogue_goblin, "modulate:a", 0, 1).finished
	rogue_goblin.queue_free()


## Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass

#
# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass



# Receives events from the `_unhandled_input()` callback.
#func handle_input(_event: InputEvent) -> void:
	#controls()


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	rogue_goblin.sprite.animation_finished.disconnect(_on_animation_finished)
